# Require the dependencies file to load the vendor libraries
require File.expand_path(File.join(File.dirname(__FILE__), "dependencies"))

class RepoCopyTemplateV1
  # ==== Parameters
  # * +input+ - The String of Xml that was built by evaluating the node.xml handler template.
  def initialize(input)
    # Set the input document attribute
    @input_document = REXML::Document.new(input)

    # Retrieve all of the handler info values and store them in a hash variable named @info_values.
    @info_values = {}
    REXML::XPath.each(@input_document, "/handler/infos/info") do |item|
      @info_values[item.attributes["name"]] = item.text.to_s.strip
    end

    # Retrieve all of the handler parameters and store them in a hash variable named @parameters.
    @parameters = {}
    REXML::XPath.each(@input_document, "/handler/parameters/parameter") do |item|
      @parameters[item.attributes["name"]] = item.text.to_s.strip
    end

    @debug_logging_enabled = ["yes","true"].include?(@info_values['enable_debug_logging'].downcase)
    @error_handling = @parameters["error_handling"]
  end

  def execute
    error_message = nil
    # error_key = nil

    begin
      path = Dir.mktmpdir("kinetic_git_handler")
      temp_dir = Paths.get(path).toFile()

      credentials_provider = 
        UsernamePasswordCredentialsProvider.new(@info_values["git_username"], @info_values["git_password"])

      clone  = Git.cloneRepository()
      clone.setURI(@parameters["source_repository"])
        .setDirectory(temp_dir)
        .setCredentialsProvider(credentials_provider)
        .call()
      puts "Repository cloned from #{@parameters["source_repository"]}" if @debug_logging_enabled
      
      git = Git.open(temp_dir)
      
      repo_config = git.getRepository().getConfig()
      repo_config.setString("remote", "destination", "url", @parameters["destination_repository"])
      repo_config.save()
      
      puts "Remote repository destination added" if @debug_logging_enabled

      git.push()
        .setRemote("destination")
        .setCredentialsProvider(credentials_provider)
        .call()
      puts "Repository pushed to #{@parameters["destination_repository"]}" if @debug_logging_enabled
      
    rescue Exception => e
      error_message = e.inspect

      # Raise the error if instructed to, otherwise will fall through to
      # return an error message.
      raise if @error_handling == "Raise Error"
    ensure
      puts "Cleaning temp dir @ #{path}" if @debug_logging_enabled
      remove_dir(path)
    end

    # Return (and escape) the results that were defined in the node.xml
    <<-RESULTS
    <results>
      <result name="Handler Error Message">#{escape(error_message)}</result>
    </results>
    RESULTS
  end

  ##############################################################################
  # General handler utility functions
  ##############################################################################

  def remove_dir(path)
    if File.directory?(path)
      Dir.foreach(path) do |file|
        if ((file.to_s != ".") and (file.to_s != ".."))
          remove_dir("#{path}/#{file}")
        end
      end
      Dir.delete(path)
    else
      File.delete(path)
    end
  end

  # This is a template method that is used to escape results values (returned in
  # execute) that would cause the XML to be invalid.  This method is not
  # necessary if values do not contain character that have special meaning in
  # XML (&, ", <, and >), however it is a good practice to use it for all return
  # variable results in case the value could include one of those characters in
  # the future.  This method can be copied and reused between handlers.
  def escape(string)
    # Globally replace characters based on the ESCAPE_CHARACTERS constant
    string.to_s.gsub(/[&"><]/) { |special| ESCAPE_CHARACTERS[special] } if string
  end
  # This is a ruby constant that is used by the escape method
  ESCAPE_CHARACTERS = {'&'=>'&amp;', '>'=>'&gt;', '<'=>'&lt;', '"' => '&quot;'}
end

# Require the dependencies file to load the vendor libraries
require File.expand_path(File.join(File.dirname(__FILE__), "dependencies"))

module JgitHelperClasses
    class JshSessionFactory < JschConfigSessionFactory
        def initialize(ssh_key_file) 
            super()
            @ssh_key_file = ssh_key_file 
        end

        def configure(host, session) 
        end

        def createDefaultJSch(fs)
            defaultJSch = super;
            defaultJSch.addIdentity(@ssh_key_file);
            return defaultJSch;
        end
    end

    class TransportCallback 
        include TransportConfigCallback
        def initialize(ssh_session_factory) 
            super()
            @ssh_session_factory = ssh_session_factory
        end

        def configure( transport )
            sshTransport = transport;
            sshTransport.setSshSessionFactory( @ssh_session_factory );
        end   
    end
end
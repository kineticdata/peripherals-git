require 'java'
require 'tempfile'

handler_path = File.expand_path(File.dirname(__FILE__))
require File.join(handler_path, "vendor", "jgit-3.5.0.jar")
require File.join(handler_path, "vendor", "jsch-0.1.55.jar")

import com.jcraft.jsch.JSchException
import java.nio.file.Paths
import org.eclipse.jgit.api.CloneCommand
import org.eclipse.jgit.api.Git
import org.eclipse.jgit.lib.StoredConfig
import org.eclipse.jgit.api.errors.GitAPIException
import org.eclipse.jgit.transport.UsernamePasswordCredentialsProvider;
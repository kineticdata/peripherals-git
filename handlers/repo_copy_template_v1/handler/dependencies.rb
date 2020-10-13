require 'java'
require 'tempfile'

handler_path = File.expand_path(File.dirname(__FILE__))
require File.join(handler_path, "vendor", "jgit-3.5.0.jar")
require File.join(handler_path, "vendor", "jsch-0.1.55.jar")

import com.jcraft.jsch.JSch
import com.jcraft.jsch.JSchException
import com.jcraft.jsch.Session
# import java.io.File
# import java.io.IOException
import java.nio.file.Paths
# import java.nio.file.Path
import org.eclipse.jgit.api.CloneCommand
import org.eclipse.jgit.api.Git
import org.eclipse.jgit.api.TransportConfigCallback
import org.eclipse.jgit.api.errors.GitAPIException
import org.eclipse.jgit.lib.StoredConfig
import org.eclipse.jgit.transport.JschConfigSessionFactory
import org.eclipse.jgit.transport.OpenSshConfig
import org.eclipse.jgit.transport.SshSessionFactory
import org.eclipse.jgit.transport.SshTransport
import org.eclipse.jgit.transport.Transport
import org.eclipse.jgit.util.FS

require File.join(handler_path, "helper_classes.rb")
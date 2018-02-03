class Daemonize < Formula
  desc "Run a command as a UNIX daemon"
  homepage "https://software.clapper.org/daemonize/"
  url "https://github.com/bmc/daemonize/archive/release-1.7.7.tar.gz"
  sha256 "b3cafea3244ed5015a3691456644386fc438102adbdc305af553928a185bea05"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c07d497534fde1e044932b881f504d9af23532b6e8673f9feab00d78fa246d7c" => :high_sierra
    sha256 "ea2e85fec6d79d5755d4ace1aa1843c6ef4333753a4ef97b9c302a97133a86a8" => :sierra
    sha256 "fe5f9187cede1a244054d497a1a8f2408f8647ffdfa717fe1daa83cca8968e69" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    dummy_script_file = testpath/"script.sh"
    output_file = testpath/"outputfile.txt"
    pid_file = testpath/"pidfile.txt"
    dummy_script_file.write <<~EOS
      #!/bin/sh
      echo "#{version}" >> "#{output_file}"
    EOS
    chmod 0700, dummy_script_file
    system "#{sbin}/daemonize", "-p", pid_file, dummy_script_file
    assert_predicate pid_file, :exist?, "The file containing the PID of the child process was not created."
    sleep(4) # sleep while waiting for the dummy script to finish
    assert_predicate output_file, :exist?, "The file which should have been created by the child process doesn't exist."
    assert_match version.to_s, output_file.read
  end
end

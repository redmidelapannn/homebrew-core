class FbiServefiles < Formula
  include Language::Python::Virtualenv
  desc "Serve local files to Nintendo 3DS via FBI remote installer"
  homepage "https://github.com/Steveice10/FBI"
  url "https://github.com/Steveice10/FBI/archive/2.5.0.tar.gz"
  sha256 "e28e62e906aad30d9894bb875905d5c532df980103a8603df8c0a9bfbf8f9544"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "982911ca8d6357260ca1f25eba84f3ae9b3b5ce37f9ffe7faffb4af1284ceaaa" => :high_sierra
    sha256 "f2a664c4e34080a03fd6136e340094a9a14f085d13bf743998ea0b6030eb3756" => :sierra
    sha256 "85ac0d65a08a2613e723d306b3c7ded425b4ba8549407d4095a788e9871ad4c3" => :el_capitan
  end

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install_and_link buildpath/"servefiles"
  end

  test do
    require "socket"

    def test_socket
      server = TCPServer.new(5000)
      client = server.accept
      client.puts "\n"
      client_response = client.gets
      client.close
      server.close
      client_response
    end

    begin
      pid = fork do
        system "#{bin}/sendurls.py", "127.0.0.1", "https://github.com"
      end
      assert_match "https://github.com", test_socket
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    begin
      touch "test.cia"
      pid = fork do
        system "#{bin}/servefiles.py", "127.0.0.1", "test.cia", "127.0.0.1", "8080"
      end
      assert_match "127.0.0.1:8080/test.cia", test_socket
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

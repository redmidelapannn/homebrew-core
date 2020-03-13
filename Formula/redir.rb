class Redir < Formula
  desc "Port redirector"
  homepage "https://web.archive.org/web/20190817033513/sammy.net/~sammy/hacks/"
  url "https://github.com/TracyWebTech/redir/archive/2.2.1-9.tar.gz"
  version "2.2.1-9"
  sha256 "7e6612a0eee1626a0e7d9888de49b9c0fa4b7f75c5c4caca7804bf73d73f01fe"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3fb0b2322b023447f6e90696ab1f9b25343f284aef4b443a0d955c5c953211f0" => :catalina
    sha256 "befe741be0f4f764ec7f4215795d914ad758b7182a73241f5f6b242652eb1ac3" => :mojave
    sha256 "9c669f3c953f4d87f96470ac4738115c217c8769ddaf28f2096bc3f9efb1e947" => :high_sierra
  end

  def install
    system "make"
    bin.install "redir"
    man1.install "redir.man"
  end

  test do
    redir_pid = fork do
      exec "#{bin}/redir", "--cport=12345", "--lport=54321"
    end
    Process.detach(redir_pid)

    nc_pid = fork do
      exec "nc -l 12345"
    end

    # Give time to processes start
    sleep(1)

    begin
      # Check if the process is running
      system "kill", "-0", redir_pid

      # Check if the port redirect works
      system "nc", "-z", "localhost", "54321"
    ensure
      Process.kill("TERM", redir_pid)
      Process.kill("TERM", nc_pid)
      Process.wait(nc_pid)
    end
  end
end

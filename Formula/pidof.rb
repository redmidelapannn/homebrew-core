class Pidof < Formula
  desc "Display the PID number for a given process name"
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/pidof_source.tar.gz"
  version "0.1.4"
  sha256 "2a2cd618c7b9130e1a1d9be0210e786b85cbc9849c9b6f0cad9cbde31541e1b8"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "e85efdff278cb799ebb91fc446f47579433698e6958d874f5b1cd9a8eb5db542" => :sierra
    sha256 "410cde2d9613b24b0910ddb6e7a761af56ffa7fcb983047780f83bdd9452c6f6" => :el_capitan
    sha256 "8281b30a611a465e510ccd6d8e08ff0635719dee34a5521a3bb8ef53d3b64021" => :yosemite
  end

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end

  test do
    (testpath/"homebrew_testing.c").write <<-EOS.undent
      #include <unistd.h>
      #include <stdio.h>

      int main()
      {
        printf("Testing Pidof\\n");
        sleep(10);
        return 0;
      }
    EOS
    system ENV.cc, "homebrew_testing.c", "-o", "homebrew_testing"
    (testpath/"homebrew_testing").chmod 0555

    pid = fork { exec "./homebrew_testing" }
    sleep 1
    begin
      assert_match(/\d+/, shell_output("#{bin}/pidof homebrew_testing"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

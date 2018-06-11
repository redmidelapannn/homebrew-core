class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.4.tar.gz"
  sha256 "ae5c688e874bf9bf1db764d08538c54f6ce9e4dc78bc5948008a304d519ad3b6"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    rebuild 1
    sha256 "1badad4f278da703c955209362b264ccc727110176180124faf1f03eb7f73eb2" => :high_sierra
    sha256 "abd9f80b70c9c29d094cd4f27520bed53df7a59f1f799cd3e8c9908516422061" => :sierra
    sha256 "872f6d29d1ade8b3feb51ead39acab169a00145d854ecba307dd9dee849ffd36" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    bind = "tcp://127.0.0.1:8000"

    pid = fork do
      exec "#{bin}/nanocat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    begin
      output = shell_output("#{bin}/nanocat --req --connect #{bind} --format ascii --data brew")
      assert_match /home/, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

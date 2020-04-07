class Nanomsg < Formula
  desc "Socket library in C"
  homepage "https://nanomsg.org/"
  url "https://github.com/nanomsg/nanomsg/archive/1.1.5.tar.gz"
  sha256 "218b31ae1534ab897cb5c419973603de9ca1a5f54df2e724ab4a188eb416df5a"
  head "https://github.com/nanomsg/nanomsg.git"

  bottle do
    rebuild 1
    sha256 "e2f5af17e5abb240bee53fa4b70791bcfd0ddd8d2ae8a021b4995e3f9cf67e19" => :catalina
    sha256 "e50fa0c0c284e24054c17641cae3f4e478a3fb99bc1d1cac8aca86b26d9aa710" => :mojave
    sha256 "feca26ce4e164cad3869ed27f85ce7a4e61a852081700cfa66cadfa7a0e16923" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

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

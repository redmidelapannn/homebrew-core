class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/v1.3.0.tar.gz"
  sha256 "e8fe50d0f79ec3243733f8b4c25099c88b2597ed1bb0d94a27c4385a2a24ecac"

  bottle do
    rebuild 1
    sha256 "f73ba6605271f02273b04663c40e8cd9249088606ff6e15c57627833acdcbe57" => :catalina
    sha256 "3b78cfb00ab0bdac94bc8e40df53dd2fc20564bbc52b76e3776516554a10d36f" => :mojave
    sha256 "87c4390755181b40e498d0f3a98cc00b9f3f09c267f665fa735818a1bbdd9f29" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", "-DNNG_ENABLE_DOC=ON", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    pid = fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    begin
      output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
      assert_match(/home/, output)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

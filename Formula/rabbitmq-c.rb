class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.8.0.tar.gz"
  sha256 "d8ed9dcb49903d83d79d7b227da35ef68c60e5e0b08d0fc1fb4e4dc577b8802b"
  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "894d3286d0eeaaa547f53aeb27c47c5298f03eea441e44df748d8c325a3ac1c5" => :sierra
    sha256 "57b660689c8d1b09745753136c8a4aa320290881cec8cb78fab2ba1233cffbbd" => :el_capitan
    sha256 "433cee0c0d986d03215fcc613ac40dd3169ce2a9894f771177f45f52cd82a39f" => :yosemite
  end

  option "without-tools", "Build without command-line tools"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "popt" if build.with? "tools"
  depends_on "openssl"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DBUILD_TESTS=OFF"
    args << "-DBUILD_API_DOCS=OFF"

    if build.with? "tools"
      args << "-DBUILD_TOOLS=ON"
    else
      args << "-DBUILD_TOOLS=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end

class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.9.0.tar.gz"
  sha256 "316c0d156452b488124806911a62e0c2aa8a546d38fc8324719cd29aaa493024"
  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d499dfdf8efd1461c2605bcb6e7f7776c3b7833695a04c27f9f0e028386af681" => :mojave
    sha256 "4e9e4785d5d15b09bab49e2191434da45d2be7a2efa9e2dc5dc772b2c172db13" => :high_sierra
    sha256 "3b0f3d800cce11a9cee1be61d0cb79f19e305980c929f67cc9fe918c36f84a2b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF", "-DBUILD_API_DOCS=OFF",
                         "-DBUILD_TOOLS=ON"
    system "make", "install"
  end

  test do
    system bin/"amqp-get", "--help"
  end
end

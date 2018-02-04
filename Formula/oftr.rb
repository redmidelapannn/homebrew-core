class Oftr < Formula
  desc "OpenFlow to YAML Translator and Microservice"
  homepage "https://github.com/byllyfish/oftr"
  url "https://launchpad.net/~byllyfish/+archive/ubuntu/oftr/+files/oftr_0.45.0.orig.tar.gz"
  sha256 "d54cdf84bf54478f51cea56dba2a42f88642031da84374a7662c1a215ab0c115"
  head "https://github.com/byllyfish/oftr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4fb1c8e39efc947b464f634ae3deb56adbd49ae0f14a9bb2752508270264999" => :high_sierra
    sha256 "00a0fdb643407b59cdcb768ed6e5f4f7b21bfaa12f07d1cbc6f4796febcf5ccf" => :sierra
    sha256 "9a0ece33203c2e0674cfe66e40183ae4fcec8a5c619acd52941d75d3171e68ed" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    args = std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.yml").write("type: HELLO")
    system "#{bin}/oftr", "encode", "--hex", "--ofversion=4", "hello.yml"
  end
end

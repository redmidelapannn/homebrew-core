class Elektra < Formula
  desc "Configuration Framework"
  homepage "https://web.libelektra.org"
  url "http://www.libelektra.org/ftp/elektra/releases/elektra-0.8.19.tar.gz"
  sha256 "cc14f09539aa95623e884f28e8be7bd67c37550d25e08288108a54fd294fd2a8"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "b0aa7ff5ea594bcb40b4b5699394a7a693c183e08cf93a8996e5879467f2e769" => :sierra
    sha256 "549fc25811695ac31985b233d60c7c970c5f9aadac67532c5c9078a01f1f67d1" => :el_capitan
    sha256 "ab9185468bbd38110c8a6ac6c9f5debde090bf368d814d6f5d497917f382de08" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    cmake_args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_PREFIX_PATH=/usr/local/opt/qt5
      -DTOOLS=ALL
    ]

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    kdb = "#{bin}/kdb"
    system kdb, "ls", "/"
    system kdb, "list"
    `#{kdb} list`.split.each { |plugin| system kdb, "check", plugin }
  end
end

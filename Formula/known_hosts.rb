class KnownHosts < Formula
  desc "Command-line manager for known hosts"
  homepage "https://github.com/markmcconachie/known_hosts"
  url "https://github.com/markmcconachie/known_hosts/archive/1.0.0.tar.gz"
  sha256 "80a080aa3850af927fd332e5616eaf82e6226d904c96c6949d6034deb397ac63"

  head "https://github.com/markmcconachie/known_hosts.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4057f87de7683d0664e22d5ff228faa39d063491bcaf16500531b4915ea441c4" => :sierra
    sha256 "9f621429c8d6f9917b11ace3d60789268a29e2e4ac81bc370f38d64cab74fc94" => :el_capitan
    sha256 "6491b27e751b07bac8a07ec14e2432e31e749d5cf81f971b0e0e9c6b74db2887" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/known_hosts", "version"
  end
end

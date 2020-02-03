class Lgogdownloader < Formula
  desc "Unofficial downloader for GOG.com games"
  homepage "https://sites.google.com/site/gogdownloader/"
  url "https://sites.google.com/site/gogdownloader/lgogdownloader-3.5.tar.gz"
  sha256 "eeeaad098929a71b5fb42d14e1ca87c73fc08010ab168687bab487a763782ada"
  revision 6

  bottle do
    cellar :any
    sha256 "e926537ff5e5276ae304b7e0408ebdc6e2f9294d96a3e3f77dcf87aa90bc99f7" => :catalina
    sha256 "c81caf9e4f55e84b978363fb08d09fae1ddabadf8d9fac02c921fb28954969cc" => :mojave
    sha256 "9de35c99bc6b8cc98130fadf74b412fae96370186162821cb584015c9661d14a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "htmlcxx"
  depends_on "jsoncpp"
  depends_on "liboauth"
  depends_on "rhash"
  depends_on "tinyxml2"

  def install
    system "cmake", ".", "-DJSONCPP_INCLUDE_DIR=#{Formula["libffi"].include}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    require "pty"

    ENV["XDG_CONFIG_HOME"] = testpath
    reader, writer = PTY.spawn(bin/"lgogdownloader", "--list", "--retries", "1")
    writer.write <<~EOS
      test@example.com
      secret
    EOS
    writer.close
    assert_equal "HTTP: Login failed", reader.read.lines.last.chomp
    reader.close
  end
end

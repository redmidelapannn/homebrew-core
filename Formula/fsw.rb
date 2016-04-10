class Fsw < Formula
  desc "File change monitor with multiple backends"
  homepage "https://emcrisostomo.github.io/fsw/"
  url "https://github.com/emcrisostomo/fsw/releases/download/1.3.9/fsw-1.3.9.tar.gz"
  sha256 "9222f76f99ef9841dc937a8f23b529f635ad70b0f004b9dd4afb35c1b0d8f0ff"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "3d02fa0e6e8a6f9518341fc3934e7b53e13ac42304b07b7088ce54384ed64371" => :el_capitan
    sha256 "2a439435d39ddd9a8c1bb978ae7ebb25415fd7a3d0c7079e6a731ecbbf035f68" => :yosemite
    sha256 "9bfb46643a462f577707b65eaf68025aa158fcd50df9b3d585de8384f56ef406" => :mavericks
  end

  def install
    ENV.append "CXXFLAGS", "-stdlib=libc++"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    io = IO.popen("#{bin}/fsw #{testpath}/test")
    begin
      (testpath/"test").write("foo")
      assert_equal File.expand_path("test"), io.gets.strip
    ensure
      Process.kill 9, io.pid
      Process.wait io.pid
    end
  end
end

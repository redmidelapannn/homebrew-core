class Xu4 < Formula
  desc "Remake of Ultima IV"
  homepage "https://xu4.sourceforge.io/"
  url "https://svn.code.sf.net/p/xu4/code/trunk/u4", :revision => "3088"
  version "1.0beta4+r3088"
  head "https://svn.code.sf.net/p/xu4/code/trunk/u4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ad5de129e31f5bc9722a2f4f4db9d497becc96acaf6abd677ec791be236bdecb" => :mojave
    sha256 "fab0c2838ef2a4e6ad5fc312582bb47e18f5e7c38d80a748f193602f76249d8b" => :high_sierra
    sha256 "625ff06533b4e18358a415325624bba668ad63f8b9eab580bfe9e3ae35217f45" => :sierra
  end

  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_mixer"

  resource "ultima4" do
    url "https://www.thatfleminggent.com/ultima/ultima4.zip", :using => :nounzip
    sha256 "94aa748cfa1d0e7aa2e518abebb994f3c18acf7edb78c3bd37cd0a4404e6ba74"
  end

  resource "u4upgrad" do
    url "https://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip",
      :using => :nounzip
    sha256 "400ac37311f3be74c1b2d7836561b2ead2b146f5162586865b0f4881225cca58"
  end

  def install
    (buildpath/"src").install resource("ultima4")
    (buildpath/"src").install resource("u4upgrad")

    cd "src" do
      # Include ultima4.zip in the bundle
      inreplace "Makefile.macosx", /# (cp \$\(ULTIMA4\))/, '\1'

      # Copy over SDL's ObjC main files
      cp_r Dir[Formula["sdl"].libexec/"*"], "macosx"

      system "make", "bundle",
             "-f", "Makefile.macosx",
             "CC=#{ENV.cc}",
             "CXX=#{ENV.cxx}",
             "PREFIX=#{HOMEBREW_PREFIX}",
             "UILIBS=-framework Cocoa -L#{Formula["sdl"].lib} -lSDL " \
                    "-L#{Formula["sdl_mixer"].lib} -lSDL_mixer " \
                    "-L#{Formula["libpng"].lib} -lpng",
             "UIFLAGS=-I#{Formula["sdl"].include}/SDL " \
                     "-I#{Formula["sdl_mixer"].include}/SDL " \
                     "-I#{Formula["libpng"].include}"
      prefix.install "XU4.app"
      bin.write_exec_script "#{prefix}/XU4.app/Contents/MacOS/u4"
    end
  end

  test do
    system "#{bin}/u4", "-help"
  end
end

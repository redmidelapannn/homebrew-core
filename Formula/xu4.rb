class Xu4 < Formula
  desc "Remake of Ultima IV"
  homepage "https://xu4.sourceforge.io/"
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/xu4/code/trunk/u4", :revision => "3088"
  else
    url "http://svn.code.sf.net/p/xu4/code/trunk/u4", :revision => "3088"
  end
  version "1.0beta4+r3088"
  head "https://svn.code.sf.net/p/xu4/code/trunk/u4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3dcc8c2945ca94e4d5382ba77066300684fe01811eac77cccad8f4722ca141e1" => :sierra
    sha256 "f6b99ad03c679cd67a81e3cd232399663864e9353aff5782f49f285e46289294" => :el_capitan
    sha256 "24486f4a7f7bb385ff1be178d5d524618590708a1a1a988c31ae9a74dcbc6fb5" => :yosemite
  end

  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "libpng"

  resource "ultima4" do
    url "http://www.thatfleminggent.com/ultima/ultima4.zip", :using => :nounzip
    sha256 "94aa748cfa1d0e7aa2e518abebb994f3c18acf7edb78c3bd37cd0a4404e6ba74"
  end

  resource "u4upgrad" do
    url "https://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip", :using => :nounzip
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

      system "make", "bundle", "-f", "Makefile.macosx",
                               "CC=#{ENV.cc}",
                               "CXX=#{ENV.cxx}",
                               "PREFIX=#{HOMEBREW_PREFIX}",
                               "UILIBS=-framework Cocoa -L#{Formula["sdl"].lib} -lSDL -L#{Formula["sdl_mixer"].lib} -lSDL_mixer -L#{Formula["libpng"].lib} -lpng",
                               "UIFLAGS=-I#{Formula["sdl"].include}/SDL -I#{Formula["sdl_mixer"].include}/SDL -I#{Formula["libpng"].include}"
      prefix.install "XU4.app"
      bin.write_exec_script "#{prefix}/XU4.app/Contents/MacOS/u4"
    end
  end

  test do
    system "#{bin}/u4", "-help"
  end
end

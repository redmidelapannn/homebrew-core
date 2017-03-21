class Xmoto < Formula
  desc "2D motocross platform game"
  homepage "https://xmoto.tuxfamily.org/"
  url "https://download.tuxfamily.org/xmoto/xmoto/0.5.11/xmoto-0.5.11-src.tar.gz"
  sha256 "a584a6f9292b184686b72c78f16de4b82d5c5b72ad89e41912ff50d03eca26b2"

  bottle do
    rebuild 1
    sha256 "f81e3818502c38ad25fd79fe198ac521d361fe06103aca0b6088901585145200" => :sierra
    sha256 "e63d150dd65ac1aa7850b248975fd22aba8d5c399655608ffadde0144b348f37" => :el_capitan
    sha256 "e9a2896c36645e6f312b9854818980cb3135948953a086fe2fb67760b2c0a8f6" => :yosemite
  end

  head do
    url "svn://svn.tuxfamily.org/svnroot/xmoto/xmoto/trunk"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "sdl_net"
  depends_on "sdl_ttf"
  depends_on "ode"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libxml2"
  depends_on "gettext" => :recommended
  depends_on "libxdg-basedir"
  depends_on "lua" => :recommended

  def install
    # Fix issues reported upstream
    # https://todo.xmoto.tuxfamily.org/index.php?do=details&task_id=812

    # Set up single precision ODE
    ENV.append_to_cflags "-DdSINGLE"

    # Use same type as Apple OpenGL.framework
    inreplace "src/glext.h", "unsigned int GLhandleARB", "void *GLhandleARB"

    # Handle quirks of C++ hash_map
    inreplace "src/include/xm_hashmap.h" do |s|
      if build.head?
        s.gsub! "tr1/", ""
        s.gsub! "::tr1", ""
      else
        s.gsub! "s2) {", "s2) const {"
      end
    end

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-xmltest",
                          "--disable-sdltest",
                          "--with-apple-opengl-framework",
                          "--with-asian-ttf-file="
    system "make", "install"
  end

  test do
    system "#{bin}/xmoto", "-h"
  end
end

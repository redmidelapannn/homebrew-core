class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.D.tar.gz"
  version "0.D"
  sha256 "6cc97b3e1e466b8585e8433a6d6010931e9a073f6ec060113161b38052d82882"
  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d7a82947f2b741eb21b502528ff7fc91db9512f6d3a472d14c7081ca1d09e1bd" => :mojave
    sha256 "4eb830bcda1ad5cc4e6a9f911034b46594c53e0620b35551fec92c60cfe2bd66" => :high_sierra
    sha256 "86d22112b1088dea8b0670d3d41a8dd127e9c44122456e65c3aea1c4c04f4808" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "lua" unless build.head?
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    ENV.cxx11

    args = %W[
      NATIVE=osx
      RELEASE=1
      OSX_MIN=#{MacOS.version}
      USE_HOME_DIR=1
      TILES=1
      SOUND=1
    ]

    args << "CLANG=1" if ENV.compiler == :clang
    args << "LUA=1" if build.stable?

    system "make", *args

    # no make install, so we have to do it ourselves
    libexec.install "cataclysm-tiles", "data", "gfx"
    libexec.install "lua" if build.stable?

    inreplace "cataclysm-launcher" do |s|
      s.change_make_var! "DIR", libexec
    end
    bin.install "cataclysm-launcher" => "cataclysm"
  end

  test do
    # make user config directory
    user_config_dir = testpath/"Library/Application Support/Cataclysm/"
    user_config_dir.mkpath

    # run cataclysm for 5 seconds
    game = fork do
      system bin/"cataclysm"
    end

    sleep 5
    Process.kill("HUP", game)

    assert_predicate user_config_dir/"config",
                     :exist?, "User config directory should exist"
    assert_predicate user_config_dir/"templates",
                     :exist?, "User template directory should exist"
    assert_predicate user_config_dir/"save",
                     :exist?, "User save directory should exist"
  end
end

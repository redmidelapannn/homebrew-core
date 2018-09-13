class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  revision 1

  stable do
    url "https://arx-libertatis.org/files/arx-libertatis-1.1.2.tar.xz"
    sha256 "82adb440a9c86673e74b84abd480cae968e1296d625b6d40c69ca35b35ed4e42"

    # Add a missing include to CMakeLists.txt
    patch do
      url "https://github.com/arx/ArxLibertatis/commit/442ba4af978160abd3856a9daec38f5b6e213cb4.patch?full_index=1"
      sha256 "de361866cc51c14f317a67dcfd3b736160a577238f931c78a525ea2864b1add9"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "135aff9b1959e13cf8eb3db199bf19960bb417f54469343e37d21c42757f301d" => :mojave
    sha256 "eea05283ebdc64acf8be60b090609b522218a2e29fcbd6208810e9cee3740ae7" => :high_sierra
    sha256 "db0253ba3ff997010ecdc3fa781ab63ffc0d1051ad4e2c9918e577fa3c760e21" => :sierra
    sha256 "a7b764e45818c3a96fedd99cbae2ed9391f2de97bdcd2a919d3038dfa9668b28" => :el_capitan
  end

  head do
    url "https://github.com/arx/ArxLibertatis.git"

    resource "arx-libertatis-data" do
      url "https://github.com/arx/ArxLibertatisData.git"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "innoextract"
  depends_on "sdl"

  conflicts_with "rnv", :because => "both install `arx` binaries"

  def install
    args = std_cmake_args

    # The patches for these aren't straightforward to backport because of
    # other changes; these minimal inreplaces get it building.
    # HEAD is fine, and the next stable release will contain these changes.
    if build.stable?
      # https://github.com/arx/ArxLibertatis/commit/39fb9a0e3a6888a6a5f040e39896e88750c89065
      inreplace "src/platform/Time.cpp", "clock_t ", "clockid_t "

      # Version parsing is broken in the current stable; fixed upstream.
      # This hardcodes the current version based on data from VERSION.
      inreplace "src/core/Version.cpp.in" do |s|
        s.gsub! "${VERSION_COUNT}", "5"
        s.gsub! "${VERSION_2}", "10"
        s.gsub! "${VERSION_0}", "1.1.2"
        s.gsub! "${GIT_SUFFIX_5}", "+Homebrew-1"
        s.gsub! "${VERSION_4}", "Rhaa Movis"
      end
    end

    # Install prebuilt icons to avoid inkscape and imagemagick deps
    if build.head?
      (buildpath/"arx-libertatis-data").install resource("arx-libertatis-data")
      args << "-DDATA_FILES=#{buildpath}/arx-libertatis-data"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    This package only contains the Arx Libertatis binary, not the game data.
    To play Arx Fatalis you will need to obtain the game from GOG.com and
    install the game data with:

      arx-install-data /path/to/setup_arx_fatalis.exe
  EOS
  end

  test do
    system "#{bin}/arx", "-h"
  end
end

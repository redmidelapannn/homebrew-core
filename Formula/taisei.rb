class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/taisei-project/taisei.git",
      :tag      => "v1.3",
      :revision => "f8ef67224f47e85f4095e32736dc21e0d46ae5b7"

  bottle do
    cellar :any
    sha256 "7e3d15a3aa18590b614c047a5a35b67286913e8d8dc0dcd7f431706a268b3aec" => :mojave
    sha256 "78ec2efedf734e4894c11d922b5d6c2aef8234e4d0c24f06011c41b5ee86050d" => :high_sierra
    sha256 "b7d9cb66d263e7998d7c078fcf616555f423526958e4cbcc50fcda0d7b6f28b2" => :sierra
  end

  # Yes, these are all build deps; the game copies them into the app bundle,
  # and doesn't require the Homebrew versions at runtime.
  depends_on "freetype" => :build
  depends_on "libpng" => :build
  depends_on "libzip" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "sdl2" => :build
  depends_on "sdl2_mixer" => :build
  depends_on "sdl2_ttf" => :build

  if MacOS.version <= :sierra
    depends_on "openssl" => :build
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def caveats
    "Sound may not work."
  end

  test do
    output = shell_output("#{prefix}/Taisei.app/Contents/MacOS/Taisei -h", 1)
    assert_match "Taisei is an open source Tōhō Project fangame.", output
  end
end

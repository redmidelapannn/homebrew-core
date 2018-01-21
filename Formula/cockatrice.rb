class Cockatrice < Formula
  desc "A cross-platform virtual tabletop for multiplayer card games"
  homepage "https://cockatrice.github.io/"
  url "https://github.com/Cockatrice/Cockatrice.git",
      :tag => "2017-11-19-Release-2.4.0",
      :revision => "4d641eb0e723bf4f83343a3b3c6650a1008793f8"
  version "2.4.0"
  version_scheme 1
  head "https://github.com/Cockatrice/Cockatrice.git"

  bottle do
    rebuild 1
    sha256 "ac49480ac8140ba520c62aa755e36469e0a65804a08702f9a68d42eddd3111f8" => :high_sierra
    sha256 "39b69b0386fab5675fe80a6536b1f7d2a3058ada2fb9a6c06e87a04722bfc50a" => :sierra
    sha256 "0b1fa6c1ef3d59379a6c5b880cb23f76af8a0dc4cdd24ed20329f364d4ad644a" => :el_capitan
  end

  depends_on :macos => :el_capitan
  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "qt"

  fails_with :clang do
    build 503
    cause "Undefined symbols for architecture x86_64: google::protobuf"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      prefix.install Dir["release/*.app"]
    end
  end

  test do
    assert_predicate prefix/"cockatrice.app/Contents/MacOS/cockatrice", :executable?
    assert_predicate prefix/"oracle.app/Contents/MacOS/oracle", :executable?
  end
end

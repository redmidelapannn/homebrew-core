class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"

  stable do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.0.1.tar.gz"
    sha256 "5ff282d8400a773ffcdf12af45a5cef98cac78a87aea7e0ce3818ab767597da2"

    patch do
      # Avoid use of activesupport version 5 (which requires Ruby >= 2.2.2)
      # https://github.com/CocoaPods/CocoaPods/pull/5602
      # https://github.com/CocoaPods/CocoaPods/commit/c6e557b
      url "https://raw.githubusercontent.com/zmwangx/patches/4cb8f3cbcf9caf1056e7ddbddb2e114ed2b18536/cocoapods/patch-activesupport-4.x.diff"
      sha256 "4448552b4c2ea952a9a30d15be50e09c2eca73f29ff6029db215afe244aa7bc9"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "58a95d26251b15929f66aade25cab68b006026cacc54126634d056d8c494f88e" => :el_capitan
    sha256 "52af086ff84157810fff565c78bd527e5b278a2844dfd38e41f9ec6360065b6b" => :yosemite
    sha256 "b0fb8dff0a99ce494d8482442649df7aa5eae22992007df245db98bc10b25320" => :mavericks
  end

  devel do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.1.0.rc.2.tar.gz"
    version "1.1.0.rc.2"
    sha256 "f2bc2108daa1e49816dd8af433d282968bb8af68bf691999144e598d9f67f50e"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end

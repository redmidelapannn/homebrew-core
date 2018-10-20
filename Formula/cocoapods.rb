class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.5.3.tar.gz"
  sha256 "04593483efe1279c93cfc2bf25866a6e1a3d0c49c0c10602b060611c1e8b5e20"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f3bf8e42c043ffed3c9e2ba23bb5f2cbd69fbfbcfdaac071fc82d61169db9c24" => :mojave
    sha256 "8284a3006ff2ad47370bbdebe31e586c96830ad6da09af0daea61d471ef0c368" => :high_sierra
    sha256 "52d14c2e021ce86bb8b6d7e2b81d0d1f1166a605e7e857bd9a5ed3ccfc3195a7" => :sierra
  end

  depends_on "ruby" if MacOS.version <= :sierra

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

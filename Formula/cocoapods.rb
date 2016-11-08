class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.1.1.tar.gz"
  sha256 "a839330c62a27ba1213a97485b4a242386359d7a38c0869ded73da7d686df5c7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b51d2b03d5472ab72d25a9d33b0fdd22cfcc15cd094f53c810e524f73cd4bdf6" => :sierra
    sha256 "ebe058bddec33086fe668947a0f637e673b13ca0fe388aae1f419abc0b8cc875" => :el_capitan
    sha256 "7a8556b84e62463616b724f4d9891a9618da76069035f794796836b659ec0a0a" => :yosemite
  end

  devel do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.2.0.beta.1.tar.gz"
    version "1.2.0.beta.1"
    sha256 "4059513df38701d48f977831dfb410de75ec9841b273684a02c4c16a0f364471"
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

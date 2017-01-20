class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.1.1.tar.gz"
  sha256 "a839330c62a27ba1213a97485b4a242386359d7a38c0869ded73da7d686df5c7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e07f410e9c810b20e808d3574d44629cf708673dbccfeb7371cdbb46fbb45a38" => :sierra
    sha256 "44b4800b6b3ca421a049b97bfdab14cbcea9b72620a2440a4c96e9ac691590cd" => :el_capitan
    sha256 "2ba74ac3dabbe4aa2bc3eba7ef53ca40444c23496d3d5965fc5cbdf7b932901e" => :yosemite
  end

  devel do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.2.0.rc.1.tar.gz"
    version "1.2.0.rc.1"
    sha256 "bb9e1266d6ea31250389ea80ed919fc3ea5cd16a2c0aa5345502ccafec6d98e7"
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

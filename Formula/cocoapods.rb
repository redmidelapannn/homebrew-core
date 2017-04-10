class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.2.0.tar.gz"
  sha256 "715caded3e7c614b5c80d132f79b005ea4a83136a69077452623698d66ce8b1b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fb8b3f8d3ef88bdc42b87410fc87227aeb00d955540fbf6647c433a7a2adeb32" => :sierra
    sha256 "539a2f8cd4b0259255c9dfd0bd8c31e9d9af794cad0330730e60a4a14402cf40" => :el_capitan
    sha256 "b0081c7f18a9942b15dd736c27c28c51a0b8be9a64230ccd96e6977e13a215d0" => :yosemite
  end

  devel do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.2.1.rc.1.tar.gz"
    version "1.2.1.rc.1"
    sha256 "0081087959a164e44795bcae95dab86868a9cd777ea646b1d0275cabad4862de"
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

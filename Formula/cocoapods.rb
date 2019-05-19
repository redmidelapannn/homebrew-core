class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.6.2.tar.gz"
  sha256 "ad6a1df72b2cc4e1407bf9e79149bb167c974177596c3c072a447d3474d8b62b"

  bottle do
    cellar :any_skip_relocation
    sha256 "17bfedd7fbc1e1846ff92bf8524a8e19a0dba884db1454323c5caf28e2ff5235" => :mojave
    sha256 "a8bf9d17ede7e5a30a44e432c812667b806ddbb0f601cb7b411cd197caa982b5" => :high_sierra
    sha256 "6a6cbb4bb332db759cbfffed409c1d5bc93b7edff8bd99bb308fa98350ffeba7" => :sierra
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

class Cocoapods < Formula
  desc "The Cocoa Dependency Manager."
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/1.1.1.tar.gz"
  sha256 "a839330c62a27ba1213a97485b4a242386359d7a38c0869ded73da7d686df5c7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8760c42fc5a86cfb7d674f5d82f18819f1a85c28965ac331c65458fb1839bdd3" => :sierra
    sha256 "bd30b41fff8eafb87286f30fb1d5ad39147b63a69100314335e1ccc20262554f" => :el_capitan
    sha256 "1f53a7d28f52eb5a1ca1fc881e4f7d2f82afc7359ad27ec0c5b7995a1e88a088" => :yosemite
  end

  devel do
    url "https://github.com/CocoaPods/CocoaPods/archive/1.2.0.beta.3.tar.gz"
    version "1.2.0.beta.3"
    sha256 "f3619ef1678d4b625699b2d30dcdad41677d7785a0e3da505cd26dab07af765a"
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

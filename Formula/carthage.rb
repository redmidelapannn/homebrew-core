class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag      => "0.33.0",
      :revision => "c8ac06e106b6b61f907918bfb2b7a5c432de4678",
      :shallow  => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2586f605a46ff034db9b7ec773874a4bb172573460f2927b56ff6cf089dc7e41" => :mojave
    sha256 "51ad07af97f934bd51f4933b328ad736e255b07c145fc215323335cefb9a72eb" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    if MacOS::Xcode.version >= "10.2" && MacOS.version < "10.14.4" && MacOS.version >= "10.14.4"
      odie "Xcode >=10.2 requires macOS >=10.14.4 to build Swift formulae."
    end

    system "make", "prefix_install", "PREFIX=#{prefix}"
    bash_completion.install "Source/Scripts/carthage-bash-completion" => "carthage"
    zsh_completion.install "Source/Scripts/carthage-zsh-completion" => "_carthage"
    fish_completion.install "Source/Scripts/carthage-fish-completion" => "carthage.fish"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system bin/"carthage", "update"
  end
end

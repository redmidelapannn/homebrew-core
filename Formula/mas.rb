class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas/archive/v1.4.2.tar.gz"
  sha256 "f9a751ff84e6dcbaedd4b2ca95b3ca623c739fd3af0b6ca950c321f2ce840bfe"
  head "https://github.com/mas-cli/mas.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "caaea8c47a2507a9fcd2d070f5b74822d9ce2903aa39fd7adafaab0bea9a7f8e" => :high_sierra
  end

  depends_on :xcode => ["9.3", :build]

  resource "cocoapods" do
    url "https://dl.bintray.com/phatblat/mas-bottles/master.tar.gz"
    sha256 "fd8f1b06a2a0276c9005241b45cc19393b7c39cfc91d08da92a307ea2416e966"
  end

  def install
    # Pre-install a shallow copy of the CocoaPods master repo
    (buildpath/".brew_home/.cocoapods/repos/master").install resource("cocoapods")

    # Install bundler, then use it to install gems used by project
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install"
    system "bundle", "exec", "pod", "install"

    xcodebuild "-workspace", "mas-cli.xcworkspace",
               "-scheme", "mas-cli Release",
               "SYMROOT=#{buildpath.realpath}"

    bin.install buildpath/"build/mas"

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
  end
end

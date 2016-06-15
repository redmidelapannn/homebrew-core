class Dvm < Formula
  desc "Docker Version Manager"
  homepage "https://github.com/getcarina/dvm"
  url "https://github.com/getcarina/dvm/archive/0.6.2.tar.gz"
  sha256 "57a14fc85c37d30c3c2265eb0f06d2fdc18273306052a5ccc748b54a5c38660c"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c5e87218edc527130859b664fd5814b4e9f8ca516a5995e33fd023e5691617fe" => :el_capitan
    sha256 "46fbaf46fa6e9057644beadf77ded7ebe2c2c84942525f801526bd41296370fc" => :yosemite
    sha256 "66753163ab5456185f863822726d1d24cc658dd497c5f3f0a0daa1ccb3102803" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dvmpath = buildpath/"src/github.com/getcarina/dvm"
    dvmpath.install Dir["{*,.git}"]

    cd dvmpath do
      system "make", "VERSION=#{version}", "COMMIT=6467884b2e25d080c25aa647bbcbbf8c12dc45bd", "UPGRADE_DISABLED=true"

      prefix.install "dvm.sh"
      (prefix/"dvm-helper").install "dvm-helper/dvm-helper"
    end
  end

  def caveats; <<-EOS.undent
    dvm is a shell function, and must be sourced before it can be used.
    Add the following command to your bash profile:

        [[ -s "$(brew --prefix dvm)/dvm.sh" ]] && source "$(brew --prefix dvm)/dvm.sh"

    EOS
  end

  test do
    output = shell_output("bash -c 'source #{prefix}/dvm.sh && dvm --version'")
    assert_match "Docker Version Manager version #{version}", output
  end
end

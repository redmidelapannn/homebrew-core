class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v0.1.2.tar.gz"
  sha256 "7c9b01926f246d07cd007b86d34b2abd6df357a8743733c8d55ab5a8bef46271"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d36592e4965c8f8e0fd04d2a2a0eefd3fea1e1285a98e77443a33b0be99a2ce" => :mojave
    sha256 "20cb1253b94720c2c972a84f31f2d2e3b0be900676d0e7a449905c485e5b75cc" => :high_sierra
    sha256 "20cb1253b94720c2c972a84f31f2d2e3b0be900676d0e7a449905c485e5b75cc" => :sierra
  end

  def install
    prefix.install %w[bin completions libexec]
  end

  def caveats
    <<~EOS
      Please add the line below to your profile of shell:

      eval "$(anyenv init -)"

      You can initialize install manifests directory by:

      anyenv install --init [git-url] [git-ref]
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/anyenv init -)\" && anyenv --version")
  end
end

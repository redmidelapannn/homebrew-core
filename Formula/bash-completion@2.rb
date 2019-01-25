class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.1+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.8/bash-completion-2.8.tar.xz"
  sha256 "c01f5570f5698a0dda8dc9cfb2a83744daa1ec54758373a6e349bd903375f54d"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ac19e2da22aa5e5ce98c017520f1d403f005a928bdc8a7d712e7165cbd9f7886" => :mojave
    sha256 "256ec2d9bb7ca04566d43c497362418e9474b42810804c597cd311f07dcc4081" => :high_sierra
    sha256 "256ec2d9bb7ca04566d43c497362418e9474b42810804c597cd311f07dcc4081" => :sierra
  end

  head do
    url "https://github.com/scop/bash-completion.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bash"

  conflicts_with "bash-completion", :because => "Differing version of same formula"

  def install
    inreplace "bash_completion", "readlink -f", "readlink"

    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following to your ~/.bash_profile:
      [[ -r "#{etc}/profile.d/bash_completion.sh" ]] && . "#{etc}/profile.d/bash_completion.sh"
  EOS
  end

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end

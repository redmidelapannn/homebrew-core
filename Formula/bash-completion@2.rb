class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.1+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.8/bash-completion-2.8.tar.xz"
  sha256 "c01f5570f5698a0dda8dc9cfb2a83744daa1ec54758373a6e349bd903375f54d"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4c464eddec982e43a336c89ce6d070580bc134bcb60088cc3a5ed5aa1468d8b2" => :mojave
    sha256 "3ad9bfc34a5daac9329c525a22efad1c8784539c5a8a72495e4da6ec5c76973b" => :high_sierra
    sha256 "3ad9bfc34a5daac9329c525a22efad1c8784539c5a8a72495e4da6ec5c76973b" => :sierra
  end

  head do
    url "https://github.com/scop/bash-completion.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bash"

  def install
    inreplace "bash_completion", "readlink -f", "readlink"

    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
    mv prefix/"etc/profile.d/bash_completion.sh", prefix/"etc/profile.d/bash_completion@2.sh"
  end

  def caveats; <<~EOS
    Add the following to your ~/.bash_profile:
      [[ -r "#{etc}/profile.d/bash_completion@2.sh" ]] && . "#{etc}/profile.d/bash_completion@2.sh"
  EOS
  end

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end

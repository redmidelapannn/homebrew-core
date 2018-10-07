class Bonniexx < Formula
  desc "Benchmark suite for file systems and hard drives"
  homepage "https://www.coker.com.au/bonnie++/"
  url "https://www.coker.com.au/bonnie++/bonnie++-1.97.3.tgz"
  mirror "https://fossies.org/linux/privat/bonnie++-1.97.3.tgz"
  sha256 "e27b386ae0dc054fa7b530aab6bdead7aea6337a864d1f982bc9ebacb320746e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2b2788287b800a6cacff3af9891d100eb175023df9afc0089d016c4fdbe48f95" => :mojave
    sha256 "77a3decb7eff2972380e43135c795c08761b501f93f594f03506ba9526e06773" => :high_sierra
    sha256 "236a177869c05d7b96e80026afeee6a2ca93f311fdaef44db49c901ee59742eb" => :sierra
  end

  # Remove the #ifdef _LARGEFILE64_SOURCE macros which not only prohibits the
  # intended functionality of splitting into 2 GB files for such filesystems but
  # also incorrectly tests for it in the first place. The ideal fix would be to
  # replace the AC_TRY_RUN() in configure.in if the fail code actually worked.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/57a21ef/bonnie%2B%2B/remove-large-file-support-macros.diff"
    sha256 "4d38a57f8a3d99405d945bb27ffe81e0ab542b520f2de6fad021a6ad3ff8a3b6"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{sbin}/bonnie++", "-s", "0"
  end
end

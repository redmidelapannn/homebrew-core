class Tractorgen < Formula
  desc "Generates ASCII tractor art"
  homepage "http://www.kfish.org/software/tractorgen/"
  url "http://www.kfish.org/software/tractorgen/dl/tractorgen-0.31.7.tar.gz"
  sha256 "469917e1462c8c3585a328d035ac9f00515725301a682ada1edb3d72a5995a8f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b0d1bc9d6e396610dc46601d93d2fe2896bc1aa95b0fcc1810b1136007b493b5" => :high_sierra
    sha256 "3cbdd9b499c5ecae513d59fe37daf76d6593eef4411c3363a67cc51b45b177e5" => :sierra
    sha256 "04c55d34f8b6501dddb87fdc8d4c634b95d43ab8c174dccb3f76e26d1239aef8" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    expected = <<-'EOS'
         r-
        _|
       / |_\_    \\
      |    |o|----\\
      |_______\_--_\\
     (O)_O_O_(O)    \\
    EOS
    assert_equal expected, shell_output("#{bin}/tractorgen 4")
  end
end

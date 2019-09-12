class PhpMtSeed < Formula
  desc "PHP mt_rand() seed cracker"
  homepage "https://www.openwall.com/php_mt_seed/"
  url "https://www.openwall.com/php_mt_seed/php_mt_seed-4.0.tar.gz"
  sha256 "28b94864a1d2988f8eb31909d3f99a166a5973e514d305c115c6cccbe978710d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2074aa249cc99d63a94ec1892b1710ad88ddfc79c9d8d358d3b351b55c12e08" => :mojave
    sha256 "b22fcae8c031ed5246daa8d901ccd1deb3a87b8277e6250ba3509adcae713ffb" => :high_sierra
    sha256 "c5b6b9263371715bab8219538d19114500428002ce92e40d32f74650a837a1c6" => :sierra
  end

  depends_on "libomp"

  def install
    system "make", "CC=#{ENV.cc}", "php_mt_seed"

    doc.install "README"
    bin.install "php_mt_seed"
    bin.install_symlink "php_mt_seed" => "php-mt-seed"
  end

  test do
    run_output = shell_output("#{bin}/php_mt_seed 2>&1 || :")
    assert_match "php_mt_seed VALUE_OR_MATCH_MIN [MATCH_MAX [RANGE_MIN RANGE_MAX]]", run_output
  end
end

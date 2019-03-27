class Hfst < Formula
  desc "Helsinki Finite-State Technology (library and application suite)"
  homepage "https://hfst.github.io/"
  url "https://github.com/hfst/hfst/releases/download/v3.15.0/hfst-3.15.0.tar.gz"
  sha256 "bf50099174a0e14a53ab4d37d514bec2347dea3d4f2ff69d652659357cdd667f"

  bottle do
    cellar :any
    sha256 "1a236a2fde407c6724eace023837afdbb0710d4069330bb537a0d95638387c1a" => :mojave
    sha256 "6eba09ae81de182fb77f1023d684c47c57e7ea4ffda6fed4adddabf0b68ff46d" => :high_sierra
    sha256 "3fd42b40bd06b6fe5f9e0692e0e3c916eb379150373b227903e70060a3b5c3a2" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Create a very simple transducer and enumerate its strings
    expected = "test\ntests\ntested\ntesting\n"
    (testpath / "test.regexp").write "test[0|s|ed|ing]"
    system (bin / "hfst-regexp2fst"), (testpath / "test.regexp"), "-o", (testpath / "test.hfst")
    assert_equal expected, shell_output("#{bin}/hfst-fst2strings #{testpath}/test.hfst")
  end
end

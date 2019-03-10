class OpenkimModelsV2 < Formula
  desc "All OpenKIM Models compatible with kim-api-v2"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/archives/collection/OpenKIM-Models-v2-2019-02-21.txz"
  sha256 "3bd30b0cf2bab314755a66eed621a77c72d3f990818d08366874149be39f208e"

  bottle do
    cellar :any
    sha256 "9950b78726bd80c6142cdeb1bf96ad1b8319356aed7b70482242513c09da472e" => :mojave
    sha256 "928925960bcab5c027247ed3d8d0866ffb0fc757ff4526ef2ca3a4c6acad31bf" => :high_sierra
    sha256 "ad8bf4fc20db14b8e7fc6e1b8d11b206b09b196b2dcac27d2f65697587b7d6dc" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "kim-api-v2"

  def install
    args = std_cmake_args
    args << "-DKIM_API_MODEL_INSTALL_PREFIX=#{lib}/kim-api-v2/models"
    args << "-DKIM_API_MODEL_DRIVER_INSTALL_PREFIX=#{lib}/kim-api-v2/model-drivers"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "kim-api-v2-collections-management list > ./out"
    system "grep", "LJ_ElliottAkerson_2015_Universal__MO_959249795837_003", "./out"
  end
end

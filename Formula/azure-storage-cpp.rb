class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v5.1.1.tar.gz"
  sha256 "29b4b0c47784ae541b0ef1b3693acba54e0d06bac78d139105a379ab1fd20333"

  bottle do
    cellar :any
    sha256 "54ab983458c43eb7d6c3badfd24c8bdb6e42be960e6ae778c3c36afe5e306c8d" => :mojave
    sha256 "61db781914f9da6f2369e50f2e4aa53c3afec9f050b20c38a232199cf8a726e9" => :high_sierra
    sha256 "117e7993789691d16630946b0f5d125f0846fed301f1b2bd84ea12cad5c35cdd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "openssl"
  depends_on "ossp-uuid"

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF", "Microsoft.WindowsAzure.Storage", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end

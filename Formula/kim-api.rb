class KimApi < Formula
  desc "The Knowledgebase of Interatomic Models (KIM) API"
  homepage "https://openkim.org"
  url "https://s3.openkim.org/kim-api/kim-api-2.1.0.txz"
  sha256 "d6b154b31b288ec0a5643db176950ed71f1ca83a146af210a1d5d01cce8ce958"

  bottle do
    sha256 "70b1bc539ba9fbd9881740ed4854be4cd5d86861795753aa345ae9c47a5a2aac" => :mojave
    sha256 "50ff6732f80d7f27e6e0978e766a2f158dd959bcf285b5f7c1baa30a84eaa480" => :high_sierra
    sha256 "93135f06607bddb177143f8c14b8a6efe84d995887150ac4b6cb114c8db03de7" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "gcc" # for gfortran

  def install
    args = std_cmake_args
    # adjust directories for system collection
    args << "-DKIM_API_SYSTEM_MODEL_DRIVERS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/model-drivers"
    args << "-DKIM_API_SYSTEM_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/models"
    args << "-DKIM_API_SYSTEM_SIMULATOR_MODELS_DIR=:#{HOMEBREW_PREFIX}/lib/openkim-models/simulator-models"
    system "cmake", ".", *args
    system "make"
    system "make", "docs"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/kim-api-collections-management list")
    assert_match "Sim_LAMMPS_LJcut_AkersonElliott_Alchemy_PbAu", output
  end
end

class SignalwireClientC < Formula
  desc "C client library for signalwire"
  homepage "https://github.com/signalwire/signalwire-c"
  url "https://files.freeswitch.org/downloads/libs/signalwire-client-c-1.0.0.tar.gz"
  sha256 "85b0493a2332b2f763a8a2f92f4e9905c7d9c49eb4be4218f5aa99b87a28dbce"

  bottle do
    sha256 "fcddbd464b7d1f27636dbf9d306bb620f0fe10e3bde4ca41ce01bbd8a9e50a99" => :mojave
    sha256 "873cd25a813eb09645d23ac3fdd34f3944b841fa59dcefdeaf22f77cd8439002" => :high_sierra
    sha256 "5775d96d9b7ffa09f30fb11f28e7c83f43e7de45d2a57a9ad5193e82de0a2d6e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libks"
  depends_on "openssl"
  depends_on "ossp-uuid"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    cd "examples/client" do
      system ENV.cc, "-I#{include}", "-L#{lib}", "-lsignalwire_client", "main.c", "-o", "test"
      pkgshare.install "test"
    end
  end

  test do
    system pkgshare/"test"
  end
end

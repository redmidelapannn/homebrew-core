class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://code.google.com/archive/p/mp4v2/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mp4v2/mp4v2-2.0.0.tar.bz2"
  sha256 "0319b9a60b667cf10ee0ec7505eb7bdc0a2e21ca7a93db96ec5bd758e3428338"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f1a27cc90e2d99edcf32cf61bb1b5e888452c3f6d18b196adae866243b1cd6d7" => :mojave
    sha256 "3c9b12dfa67428b35c6c57d72e59b1c25e32a09d4822b900b2dc3df8101dfbfb" => :high_sierra
    sha256 "cfd4350e0922c2bdb8728e84509787b8801abf6f3690ada8a3d0ea5cbd328c1d" => :sierra
  end

  conflicts_with "bento4",
    :because => "both install `mp4extract` and `mp4info` binaries"
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mp4art --version")
  end
end
__END__
diff --git a/src/rtphint.cpp b/src/rtphint.cpp
index e07309d..1eb01f5 100644
--- a/src/rtphint.cpp
+++ b/src/rtphint.cpp
@@ -339,7 +339,7 @@ void MP4RtpHintTrack::GetPayload(
                 pSlash = strchr(pSlash, '/');
                 if (pSlash != NULL) {
                     pSlash++;
-                    if (pSlash != '\0') {
+                    if (*pSlash != '\0') {
                         length = (uint32_t)strlen(pRtpMap) - (pSlash - pRtpMap);
                         *ppEncodingParams = (char *)MP4Calloc(length + 1);
                         strncpy(*ppEncodingParams, pSlash, length);

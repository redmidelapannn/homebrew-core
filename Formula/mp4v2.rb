class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://code.google.com/archive/p/mp4v2/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mp4v2/mp4v2-2.0.0.tar.bz2"
  sha256 "0319b9a60b667cf10ee0ec7505eb7bdc0a2e21ca7a93db96ec5bd758e3428338"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bd4c8e435216cbfc4ed60030e1cd4135156643f8befa1477061c1e59292394bb" => :mojave
    sha256 "359eecfb160a0d31975961933b50c7ba512891aedd053e3e9153edba1da364c3" => :high_sierra
    sha256 "6cab2b32c845f6d54cdb8d64c558126cec39c27fb77a92f204bb8abda1c0ccfa" => :sierra
    sha256 "52d299e61126db288d73a3e6e8b40c3eff25af1c7498c4a74787dce2dda02e9a" => :el_capitan
    sha256 "14ca4b71690959d461d41b4338be70005de4553566996677f973094c1a56c3fb" => :yosemite
    sha256 "bb51275338ca5b157b303fb9d024922c9b73ddcac69973ba2fe9d880ad6dc914" => :mavericks
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

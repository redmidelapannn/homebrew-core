class GetFlashVideos < Formula
  desc "Download or play videos from various Flash-based websites"
  homepage "https://github.com/monsieurvideo/get-flash-videos"
  url "https://github.com/monsieurvideo/get-flash-videos/archive/1.25.92.tar.gz"
  sha256 "e4b64eb51058e55f07cb66b7c50b11ea1ca0a57162946b7af96db748ed22cdcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f09bd2333d59e2f9b74cad060ab24c874a1d98728d40e41b55cc2d4a6b45ebb" => :el_capitan
    sha256 "bb59c101f017b084ab672c853379d43a82088bbb30a39ee079993cb854d4b2fe" => :yosemite
    sha256 "007f0b643544676053327d08a9d9a1bbe26d658876ae0623f76f2656867695f7" => :mavericks
  end

  depends_on "rtmpdump"

  resource "Crypt::Blowfish_PP" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTBM/Crypt-Blowfish_PP-1.12.tar.gz"
    sha256 "714f1a3e94f658029d108ca15ed20f0842e73559ae5fc1faee86d4f2195fcf8c"
  end

  resource "LWP::Protocol" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/libwww-perl-6.15.tar.gz"
    sha256 "6f349d45c21b1ec0501c4437dfcb70570940e6c3d5bff783bd91d4cddead8322"
  end

  resource "Tie::IxHash" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz"
    sha256 "fabb0b8c97e67c9b34b6cc18ed66f6c5e01c55b257dcf007555e0b027d4caf56"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/WWW-Mechanize-1.75.tar.gz"
    sha256 "5310051feb66c6ef9f7a4c070c66ec6092932129fc9cd18bba009ce999b7930b"
  end

  resource "Term::ProgressBar" do
    url "https://cpan.metacpan.org/authors/id/S/SZ/SZABGAB/Term-ProgressBar-2.17.tar.gz"
    sha256 "c1e0602c738a91fe54b01bcaa0d1a898b07ef6815c55eb2ebd6da4e3be20f696"
  end

  resource "Class::MethodMaker" do
    url "https://cpan.metacpan.org/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.24.tar.gz"
    sha256 "5eef58ccb27ebd01bcde5b14bcc553b5347a0699e5c3e921c7780c3526890328"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_create_path "PERL5LIB", lib/"perl5"
    system "make"
    (lib/"perl5").install "blib/lib/FlashVideo"

    bin.install "bin/get_flash_videos"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    chmod 0755, libexec/"bin/get_flash_videos"

    man1.install "blib/man1/get_flash_videos.1"
  end

  test do
    file = "BBC_-__Do_whatever_it_takes_to_get_him_to_talk.flv"
    system bin/"get_flash_videos", "http://news.bbc.co.uk/2/hi/programmes/hardtalk/9560793.stm"
    assert File.exist?(file), "Failed to download #{file}!"
  end
end

class QemuM1 < Formula
  desc "QEMU with Apple Silicon (M1) support"
  homepage "https://www.qemu.org/"
  url "https://github.com/slp/qemu/releases/download/v6.1.0-m1-r1/qemu-6.1.0-m1-r1.tgz"
  version "6.1.0-m1-r1"
  sha256 "d63f75222f2b04a7efcc57f3159c01a29a2301ef12ed33e4b6d27950f6b4e83c"
  license "GPL-2.0-only"

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "qemu"
  depends_on "snappy"
  depends_on "vde"

  fails_with gcc: "5"

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --target-list=aarch64-softmmu
      --disable-tools
      --disable-bsd-user
      --disable-guest-agent
      --enable-curses
      --enable-libssh
      --enable-slirp=system
      --enable-vde
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --disable-sdl
      --disable-gtk
      --enable-cocoa
    ]
    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    system "./configure", *args
    system "make", "V=1"
    bin.mkdir
    cp "build/qemu-system-aarch64", bin/"qemu-m1"
  end

  test do
    assert_match "QEMU Project", shell_output("#{bin}/qemu-m1 --version")
  end
end

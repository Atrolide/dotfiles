PACMAN_LIST := packages/pacman.txt
YAY_LIST    := packages/yay.txt

PACMAN_CMD := sudo pacman -S --needed --noconfirm
YAY_CMD    := yay -S --needed --noconfirm

TOOLS := alacritty helix cava fastfetch glow hypr lsd mako rofi sddm waybar zathura

.PHONY: all $(TOOLS)

all: $(TOOLS)

define INSTALL_SECTION
	@echo "==> Installing pacman packages for $(1)..."
	@awk '/^# $(1)$$$$/ {flag=1; next} /^#/ {flag=0} flag && NF' $(PACMAN_LIST) | xargs -r $(PACMAN_CMD)
	@echo "==> Installing yay packages for $(1)..."
	@awk '/^# $(1)$$$$/ {flag=1; next} /^#/ {flag=0} flag && NF' $(YAY_LIST) | xargs -r $(YAY_CMD)
endef

$(foreach tool,$(TOOLS),$(eval $(tool): ; $(call INSTALL_SECTION,$(tool))))

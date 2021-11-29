// Some Basic Colors
// NOTE: Custom raylib color palette for amazing visuals on WHITE background
#define _LIGHTGRAY_  { 200, 200, 200, 255 }   // Light Gray
#define _GRAY_       { 130, 130, 130, 255 }   // Gray
#define _DARKGRAY_   { 80, 80, 80, 255 }      // Dark Gray
#define _YELLOW_     { 253, 249, 0, 255 }     // Yellow
#define _GOLD_       { 255, 203, 0, 255 }     // Gold
#define _ORANGE_     { 255, 161, 0, 255 }     // Orange
#define _PINK_       { 255, 109, 194, 255 }   // Pink
#define _RED_        { 230, 41, 55, 255 }     // Red
#define _MAROON_     { 190, 33, 55, 255 }     // Maroon
#define _GREEN_      { 0, 228, 48, 255 }      // Green
#define _LIME_       { 0, 158, 47, 255 }      // Lime
#define _DARKGREEN_  { 0, 117, 44, 255 }      // Dark Green
#define _SKYBLUE_    { 102, 191, 255, 255 }   // Sky Blue
#define _BLUE_       { 0, 121, 241, 255 }     // Blue
#define _DARKBLUE_   { 0, 82, 172, 255 }      // Dark Blue
#define _PURPLE_     { 200, 122, 255, 255 }   // Purple
#define _VIOLET_     { 135, 60, 190, 255 }    // Violet
#define _DARKPURPLE_ { 112, 31, 126, 255 }    // Dark Purple
#define _BEIGE_      { 211, 176, 131, 255 }   // Beige
#define _BROWN_      { 127, 106, 79, 255 }    // Brown
#define _DARKBROWN_  { 76, 63, 47, 255 }      // Dark Brown

#define _WHITE_      { 255, 255, 255, 255 }   // White
#define _BLACK_      { 0, 0, 0, 255 }         // Black
#define _BLANK_      { 0, 0, 0, 0 }           // Blank (Transparent)
#define _MAGENTA_    { 255, 0, 255, 255 }     // Magenta
#define _RAYWHITE_   { 245, 245, 245, 255 }   // My own White (raylib logo)


struct named_color {
    const char *name;
    Color color;
};

const struct named_color named_colors2[] = {
    {"beige", _BEIGE_},
    {"black", _BLACK_},
    {"blank", _BLANK_},
    {"blue", _BLUE_},
    {"brown", _BROWN_},
    {"dark-blue", _DARKBLUE_},
    {"dark-brown", _DARKBROWN_},
    {"dark-gray", _DARKGRAY_},
    {"dark-green", _DARKGREEN_},
    {"dark-purple", _DARKPURPLE_},
    {"gold", _GOLD_},
    {"gray", _GRAY_},
    {"green", _GREEN_},
    {"light-gray", _LIGHTGRAY_},
    {"lime", _LIME_},
    {"magenta", _MAGENTA_},
    {"maroon", _MAROON_},
    {"orange", _ORANGE_},
    {"pink", _PINK_},
    {"purple", _PURPLE_},
    {"ray-white", _RAYWHITE_},
    {"ray-white", _RAYWHITE_},
    {"red", _RED_},
    {"sky-blue", _SKYBLUE_},
    {"violet", _VIOLET_},
    {"white", _WHITE_},
    {"yellow",_YELLOW_},
};

static Color jaylib_getcolor(const Janet *argv, int32_t n) {
    Janet x = argv[n];
    const Janet *els = NULL;
    int32_t len = 0;
    if (janet_indexed_view(x, &els, &len)) {
        if (len == 3 || len == 4) {
            uint8_t r = (uint8_t) (janet_getnumber(els, 0) * 255);
            uint8_t g = (uint8_t) (janet_getnumber(els, 1) * 255);
            uint8_t b = (uint8_t) (janet_getnumber(els, 2) * 255);
            uint8_t a = (len == 4)
                ? (uint8_t)(janet_getnumber(els, 3) * 255)
                : 255;
            return (Color) { r, g, b, a };
        } else {
            janet_panicf("expected 3 or 4 color components, got %d", len);
        }
    } else if (janet_checktype(x, JANET_NUMBER)) {
        int64_t value = janet_getinteger64(argv, n);
        return (Color) {
            ((value >> 16) & 0xFF), // red
            ((value >> 8)  & 0xFF), // green
            ((value >> 0)  & 0xFF), // blue
            ((value >> 24) & 0xFF)  // alpha
        };
    } else {
        const uint8_t *nameu = janet_getkeyword(argv, n);
        const char *name = (const char *)nameu;
        int hi = (sizeof(named_colors2) / sizeof(struct named_color)) - 1;
        int lo = 0;
        while (lo <= hi) {
            int mid = (lo + hi) / 2;
            int cmp = strcmp(named_colors2[mid].name, name);
            if (cmp < 0) {
                lo = mid + 1;
            } else if (cmp > 0) {
                hi = mid - 1;
            } else {
                return named_colors2[mid].color;
            }
        }
        janet_panicf("unknown color :%s", name);
    }
}
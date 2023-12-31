// Bundled with Packemon: https://packemon.dev
// Platform: browser, Support: stable, Format: esm

/**
 * Append a skin tone index (number) to the end of a shortcode.
 */
function appendSkinToneIndex(shortcode, emoji, prefix = '') {
  return `${shortcode}_${prefix}${Array.isArray(emoji.tone) ? emoji.tone.join('-') : emoji.tone}`;
}

const SEQUENCE_REMOVAL_PATTERN = /200D|FE0E|FE0F/g; // Use numbers instead of string values, as the filesize is greatly reduced.

const TEXT = 0;
const EMOJI = 1;
const FEMALE = 0;
const MALE = 1;
const FULLY_QUALIFIED = 0;
const MINIMALLY_QUALIFIED = 1;
const UNQUALIFIED = 2;
const LIGHT_SKIN = 1;
const MEDIUM_LIGHT_SKIN = 2;
const MEDIUM_SKIN = 3;
const MEDIUM_DARK_SKIN = 4;
const DARK_SKIN = 5;
const GROUP_KEY_SMILEYS_EMOTION = 'smileys-emotion';
const GROUP_KEY_PEOPLE_BODY = 'people-body';
const GROUP_KEY_ANIMALS_NATURE = 'animals-nature';
const GROUP_KEY_FOOD_DRINK = 'food-drink';
const GROUP_KEY_TRAVEL_PLACES = 'travel-places';
const GROUP_KEY_ACTIVITIES = 'activities';
const GROUP_KEY_OBJECTS = 'objects';
const GROUP_KEY_SYMBOLS = 'symbols';
const GROUP_KEY_FLAGS = 'flags';
const GROUP_KEY_COMPONENT = 'component';
const SKIN_KEY_LIGHT = 'light';
const SKIN_KEY_MEDIUM_LIGHT = 'medium-light';
const SKIN_KEY_MEDIUM = 'medium';
const SKIN_KEY_MEDIUM_DARK = 'medium-dark';
const SKIN_KEY_DARK = 'dark'; // Important release versions and locales in generating accurate data.

const LATEST_EMOJI_VERSION = '14.0';
const LATEST_UNICODE_VERSION = '14.0.0';
const LATEST_CLDR_VERSION = '40';
const FIRST_UNICODE_EMOJI_VERSION = '6.0.0';
const EMOJI_VERSIONS = ['1.0', '2.0', '3.0', '4.0', '5.0', '11.0', '12.0', '12.1', '13.0', '13.1', '14.0'];
const UNICODE_VERSIONS = ['6.0', '6.1', '6.2', '6.3', '7.0', '8.0', '9.0', '10.0', '11.0', '12.0', '12.1', '13.0', '14.0'];
const SUPPORTED_LOCALES = ['da', // Danish
'de', // German
'en', // English
'en-gb', // English (Great Britain)
'es', // Spanish
'es-mx', // Spanish (Mexico)
'et', // Estonian
'fi', // Finnish
'fr', // French
'hu', // Hungarian
'it', // Italian
'ja', // Japanese
'ko', // Korean
'lt', // Lithuanian
'ms', // Malay
'nb', // Norwegian
'nl', // Dutch
'pl', // Polish
'pt', // Portuguese
'ru', // Russian
'sv', // Swedish
'th', // Thai
'uk', // Ukrainian
'zh', // Chinese
'zh-hant' // Chinese (Traditional)
]; // Special options for emoticon permutations.

const EMOTICON_OPTIONS = {
  // 🧙‍♂️ man mage
  ':{>': {
    withNose: false
  },
  // 💔 broken heart
  '</3': {
    isFace: false
  },
  // ❤️ red heart
  '<3': {
    isFace: false
  },
  // 🤘 sign of the horns
  '\\m/': {
    isFace: false
  },
  '\\M/': {
    isFace: false
  },
  // 👹 ogre
  '0)': {
    withNose: false
  }
};

function getFetchUrl(path, version, cdnUrl) {
  let fetchUrl = `https://cdn.jsdelivr.net/npm/emojibase-data@${version}/${path}`;

  if (typeof cdnUrl === 'function') {
    fetchUrl = cdnUrl(path, version);
  } else if (typeof cdnUrl === 'string') {
    fetchUrl = `${cdnUrl}/${path}`;
  }

  if (process.env.NODE_ENV !== "production") {
    if (!path || !path.endsWith('.json')) {
      throw new Error('A valid JSON dataset is required to fetch.');
    }

    if (!fetchUrl || !/^https?:\/\//.test(fetchUrl) || !fetchUrl.endsWith('.json')) {
      throw new Error('A valid CDN url is required to fetch.');
    }

    if (!version) {
      throw new Error('A valid release version is required.');
    }
  }

  return fetchUrl;
}
/**
 * This function will fetch `emojibase-data` JSON files from our CDN, parse them,
 * and return the response. It requires a file path relative to the `emojibase-data` package
 * as the 1st argument and an optional object of options as the 2rd argument.
 *
 * ```ts
 * import { fetchFromCDN } from 'emojibase';
 *
 * await fetchFromCDN('ja/compact.json', { version: '2.1.3' });
 * await fetchFromCDN('ja/compact.json', { cdnUrl: 'https://example.com/cdn/emojidata/latest' });
 * await fetchFromCDN('ja/compact.json', {
 *     cdnUrl: (path: string, version: string) => {
 *         return `https://example.com/cdn/emojidata/${version}/${path}`;
 *     }
 * });
 * ```
 */


async function fetchFromCDN(path, options = {}) {
  const {
    local = false,
    version = 'latest',
    cdnUrl,
    ...opts
  } = options;
  const fetchUrl = getFetchUrl(path, version, cdnUrl);
  const storage = local ? localStorage : sessionStorage;
  const cacheKey = `emojibase/${version}/${path}`;
  const cachedData = storage.getItem(cacheKey); // Check the cache first

  if (cachedData) {
    return Promise.resolve(JSON.parse(cachedData));
  } // eslint-disable-next-line compat/compat


  const response = await fetch(fetchUrl, {
    credentials: 'omit',
    mode: 'cors',
    redirect: 'error',
    ...opts
  });

  if (!response.ok) {
    throw new Error('Failed to load Emojibase dataset.');
  }

  const data = await response.json();

  try {
    storage.setItem(cacheKey, JSON.stringify(data));
  } catch {// Do not allow quota errors to break the app
  }

  return data;
}

const ALIASES = {
  discord: 'joypixels',
  slack: 'iamcal'
};
/**
 * Fetches and returns localized shortcodes for the defined preset from our CDN.
 * The response is a mapping of emoji hexcodes to shortcodes (either a string or array of strings).
 * Uses `fetchFromCDN` under the hood.
 *
 * ```ts
 * import { fetchShortcodes } from 'emojibase';
 *
 * await fetchShortcodes('ja', 'cldr', { version: '2.1.3' });
 * ```
 */

async function fetchShortcodes(locale, preset, options) {
  var _ALIASES$preset;

  return fetchFromCDN(`${locale}/shortcodes/${(_ALIASES$preset = ALIASES[preset]) !== null && _ALIASES$preset !== void 0 ? _ALIASES$preset : preset}.json`, options);
}
/**
 * Will join shortcodes from multiple shortcode datasets into a single emoji object
 * using its hexcode. Will remove duplicates in the process.
 */


function joinShortcodesToEmoji(emoji, shortcodeDatasets) {
  if (shortcodeDatasets.length === 0) {
    return emoji;
  }

  const list = new Set(emoji.shortcodes);
  shortcodeDatasets.forEach(dataset => {
    const shortcodes = dataset[emoji.hexcode];

    if (Array.isArray(shortcodes)) {
      shortcodes.forEach(code => list.add(code));
    } else if (shortcodes) {
      list.add(shortcodes);
    }
  });
  emoji.shortcodes = [...list];

  if (emoji.skins) {
    emoji.skins.forEach(skin => {
      joinShortcodesToEmoji(skin, shortcodeDatasets);
    });
  }

  return emoji;
}

function flattenEmojiData(data, shortcodeDatasets = []) {
  const emojis = [];
  data.forEach(emoji => {
    if (emoji.skins) {
      // Dont include nested skins array
      const {
        skins,
        ...baseEmoji
      } = emoji;
      emojis.push(joinShortcodesToEmoji(baseEmoji, shortcodeDatasets)); // Push each skin modification into the root list

      skins.forEach(skin => {
        const skinEmoji = { ...skin
        }; // Inherit tags from parent if they exist

        if (baseEmoji.tags) {
          skinEmoji.tags = [...baseEmoji.tags];
        }

        emojis.push(joinShortcodesToEmoji(skinEmoji, shortcodeDatasets));
      });
    } else {
      emojis.push(joinShortcodesToEmoji(emoji, shortcodeDatasets));
    }
  });
  return emojis;
}

function joinShortcodes(emojis, shortcodeDatasets) {
  if (shortcodeDatasets.length === 0) {
    return emojis;
  }

  emojis.forEach(emoji => {
    joinShortcodesToEmoji(emoji, shortcodeDatasets);
  });
  return emojis;
}

async function fetchEmojis(locale, options = {}) {
  const {
    compact = false,
    flat = false,
    shortcodes: presets = [],
    ...opts
  } = options;
  const emojis = await fetchFromCDN(`${locale}/${compact ? 'compact' : 'data'}.json`, opts);
  let shortcodes = [];

  if (presets.length > 0) {
    shortcodes = await Promise.all(presets.map(preset => {
      let promise;

      if (preset.includes('/')) {
        const [customLocale, customPreset] = preset.split('/');
        promise = fetchShortcodes(customLocale, customPreset, opts);
      } else {
        promise = fetchShortcodes(locale, preset, opts);
      } // Ignore as the primary dataset should still load


      return promise.catch(() => ({}));
    }));
  }

  return flat ? flattenEmojiData(emojis, shortcodes) : joinShortcodes(emojis, shortcodes);
}
/**
 * Fetches and returns localized messages for emoji related information like groups and sub-groups.
 * Uses `fetchFromCDN` under the hood.
 *
 * ```ts
 * import { fetchMessages } from 'emojibase';
 *
 * await fetchMessages('zh', { version: '2.1.3' });
 * ```
 */


async function fetchMessages(locale, options) {
  return fetchFromCDN(`${locale}/messages.json`, options);
}
/**
 * This function will convert an array of numerical codepoints to a literal emoji Unicode character.
 *
 * ```ts
 * import { fromCodepointToUnicode } from 'emojibase';
 *
 * fromCodepointToUnicode([128104, 8205, 128105, 8205, 128103, 8205, 128102]); // 👨‍👩‍👧‍👦
 * ```
 */


function fromCodepointToUnicode(codepoint) {
  return String.fromCodePoint(...codepoint);
}
/**
 * This function will convert a hexadecimal codepoint to an array of numerical codepoints.
 * By default, it will split the hexcode using a dash, but can be customized with the 2nd argument.
 *
 * ```ts
 * import { fromHexcodeToCodepoint } from 'emojibase';
 *
 * fromHexcodeToCodepoint('270A-1F3FC'); // [9994, 127996]
 * fromHexcodeToCodepoint('270A 1F3FC', ' '); // [9994, 127996]
 * ```
 */


function fromHexcodeToCodepoint(code, joiner = '-') {
  return code.split(joiner).map(point => Number.parseInt(point, 16));
}
/**
 * This function will convert a literal emoji Unicode character into a dash separated
 * hexadecimal codepoint. Unless `false` is passed as the 2nd argument, zero width
 * joiner's and variation selectors are removed.
 *
 * ```ts
 * import { fromUnicodeToHexcode } from 'emojibase';
 *
 * fromUnicodeToHexcode('👨‍👩‍👧‍👦'); // 1F468-1F469-1F467-1F466
 * fromUnicodeToHexcode('👨‍👩‍👧‍👦', false); // 1F468-200D-1F469-200D-1F467-200D-1F466
 * ```
 */


function fromUnicodeToHexcode(unicode, strip = true) {
  const hexcode = [];
  [...unicode].forEach(codepoint => {
    var _codepoint$codePointA, _codepoint$codePointA2;

    let hex = (_codepoint$codePointA = (_codepoint$codePointA2 = codepoint.codePointAt(0)) === null || _codepoint$codePointA2 === void 0 ? void 0 : _codepoint$codePointA2.toString(16).toUpperCase()) !== null && _codepoint$codePointA !== void 0 ? _codepoint$codePointA : '';

    while (hex.length < 4) {
      hex = `0${hex}`;
    }

    if (!strip || strip && !hex.match(SEQUENCE_REMOVAL_PATTERN)) {
      hexcode.push(hex);
    }
  });
  return hexcode.join('-');
}
/**
 * This function will generate multiple permutations of a base emoticon character.
 * The following permutations will occur:
 *
 * - `)` mouth will be replaced with `]` and `}`. The same applies to sad/frowning mouths.
 * - `/` mouth will be replaced with `\`.
 * - `:` eyes will be replaced with `=`.
 * - Supports a `-` nose, by injecting between the eyes and mouth.
 * - Supports both uppercase and lowercase variants.
 *
 * ```ts
 * import { generateEmoticonPermutations } from 'emojibase';
 *
 * generateEmoticonPermutations(':)'); // =-), =-}, :-], =-], :-}, :-), =}, =], =), :}, :], :)
 * ```
 *
 * > The base emoticon must follow a set of naming guidelines to work properly.
 *
 * Furthermore, this function accepts an options object as the 2nd argument, as a means to customize
 * the output.
 *
 * - `isFace` (bool) - Toggles face permutations (mouth and eye variants). Defaults to `true`.
 * - `withNose` (bool) - Toggles nose inclusion. Defaults to `true`.
 *
 * ```ts
 * generateEmoticonPermutations(':)', { withNose: false }); // =}, =], =), :}, :], :)
 * generateEmoticonPermutations('\\m/', { isFace: false }); // \m/, \M/
 * ```
 */


function generateEmoticonPermutations(emoticon, options = {}) {
  const {
    isFace = true,
    withNose = true
  } = options;
  const list = [emoticon]; // Uppercase variant

  if (emoticon.toUpperCase() !== emoticon) {
    list.push(...generateEmoticonPermutations(emoticon.toUpperCase(), options));
  }

  if (isFace) {
    // Backwards slash mouth variant
    if (emoticon.includes('/')) {
      list.push(...generateEmoticonPermutations(emoticon.replace('/', '\\'), options));
    } // Bracket and curly brace mouth variants


    if (emoticon.includes(')')) {
      list.push(...generateEmoticonPermutations(emoticon.replace(')', ']'), options), ...generateEmoticonPermutations(emoticon.replace(')', '}'), options));
    }

    if (emoticon.includes('(')) {
      list.push(...generateEmoticonPermutations(emoticon.replace('(', '['), options), ...generateEmoticonPermutations(emoticon.replace('(', '{'), options));
    } // Eye variant


    if (emoticon.includes(':')) {
      list.push(...generateEmoticonPermutations(emoticon.replace(':', '='), options));
    } // Nose variant for ALL


    if (withNose) {
      list.forEach(emo => {
        if (!emo.includes('-')) {
          list.push(`${emo.slice(0, -1)}-${emo.slice(-1)}`);
        }
      });
    }
  } // Sort from longest to shortest


  list.sort((a, b) => b.length - a.length);
  return [...new Set(list)];
}

const STRIP_PATTERN = new RegExp(`(-| )?(${SEQUENCE_REMOVAL_PATTERN.source})`, 'g');
/**
 * This function will strip zero width joiners (`200D`) and variation selectors
 * (`FE0E`, `FE0F`) from a hexadecimal codepoint.
 *
 * ```ts
 * import { stripHexcode } from 'emojibase';
 *
 * stripHexcode('1F468-200D-2695-FE0F'); // 1F468-2695
 * ```
 */

function stripHexcode(hexcode) {
  return hexcode.replace(STRIP_PATTERN, '');
}

export { DARK_SKIN, EMOJI, EMOJI_VERSIONS, EMOTICON_OPTIONS, FEMALE, FIRST_UNICODE_EMOJI_VERSION, FULLY_QUALIFIED, GROUP_KEY_ACTIVITIES, GROUP_KEY_ANIMALS_NATURE, GROUP_KEY_COMPONENT, GROUP_KEY_FLAGS, GROUP_KEY_FOOD_DRINK, GROUP_KEY_OBJECTS, GROUP_KEY_PEOPLE_BODY, GROUP_KEY_SMILEYS_EMOTION, GROUP_KEY_SYMBOLS, GROUP_KEY_TRAVEL_PLACES, LATEST_CLDR_VERSION, LATEST_EMOJI_VERSION, LATEST_UNICODE_VERSION, LIGHT_SKIN, MALE, MEDIUM_DARK_SKIN, MEDIUM_LIGHT_SKIN, MEDIUM_SKIN, MINIMALLY_QUALIFIED, SEQUENCE_REMOVAL_PATTERN, SKIN_KEY_DARK, SKIN_KEY_LIGHT, SKIN_KEY_MEDIUM, SKIN_KEY_MEDIUM_DARK, SKIN_KEY_MEDIUM_LIGHT, SUPPORTED_LOCALES, TEXT, UNICODE_VERSIONS, UNQUALIFIED, appendSkinToneIndex, fetchEmojis, fetchFromCDN, fetchMessages, fetchShortcodes, flattenEmojiData, fromCodepointToUnicode, fromHexcodeToCodepoint, fromUnicodeToHexcode, generateEmoticonPermutations, joinShortcodes, joinShortcodesToEmoji, stripHexcode };
//# sourceMappingURL=index.js.map

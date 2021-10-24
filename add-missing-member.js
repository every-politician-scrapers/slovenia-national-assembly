const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label) => {
  qualifiers = {
    P2937: meta.legislature.term.id,
    P580: '2018-06-03',
    P2715: 'Q27976460',
  }

  source = {
    P143:  'Q14380',
    P4656: 'https://sl.wikipedia.org/w/index.php?title=Seznam_poslancev_8._Dr%C5%BEavnega_zbora_Republike_Slovenije&oldid=5429029',
    P813:  new Date().toISOString().split('T')[0],
  }

  return {
    type: 'item',
    labels: {
      en: label,
      sl: label,
    },
    descriptions: {
      en: 'Slovenian politician',
    },
    claims: {
      P31: 'Q5', // human
      P106: 'Q82955', // politician
      P39 : {
        value:      meta.legislature.member,
        qualifiers: qualifiers,
        references: source,
      }
    }
  }
}

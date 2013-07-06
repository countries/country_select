== 1.2.0 2013-07-06

  * Country names have been synced with UTF-8 encoding to the list of
    countries on [Wikipedia's page for the ISO-3166 standard](https://en.wikipedia.org/wiki/ISO_3166-1).
    * NOTE: This could be a breaking change with some of the country
      names that have been fixed since the list was last updated.
    * For more information you can checkout all country mappings with
      `::CountrySelect::COUNTRIES`

  * You can now store your country values using the
    [ISO-3166 Alpha-2 codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
    with the `iso_codes` option. See the README.md for details.
    * This should help alleviate the problem of country names
      in ISO-3166 being changed and/or corrected.

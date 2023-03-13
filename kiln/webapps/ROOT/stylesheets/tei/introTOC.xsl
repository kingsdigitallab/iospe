<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="http://apache.org/cocoon/i18n/2.1">

    <!-- English version table of contents for the Introduction -->
    <xsl:variable name="introTOC-en">
        <div class="row">
            <div class="large-12 columns">
                <div class="collapse-container">
                    <p>
                        <a href="#" class="toggler">Contents <span
                                class="fa fa-caret-right"/></a>
                    </p>
                    <div class="expanded hidden-content">
                        <ul>
                            <li>
                                <a href="introduction.html#I-">Content and organisation</a>
                                <ul>
                                    <li>
                                        <a href="introduction.html#I-1-">Structure of the volume</a>
                                        <ul>
                                            <li>
                                                <a href="introduction.html#I-1-A-">Preliminary
                                                  remarks</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#I-1-B-">Inscriptions</a>
                                                <!--<ul>
                                                  <li>
                                                  <a href="introduction.html#I-1-B-a-">Region</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#I-1-B-b-">Find
                                                  place</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#I-1-B-c-">Category of
                                                  text</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#I-1-B-d-">Formula</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#I-1-B-e-">Name</a>
                                                  </li>
                                                  </ul>-->
                                            </li>
                                            <li>
                                                <a href="introduction.html#I-1-C-">Indices and
                                                  Concordances</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="introduction.html#I-2-">Criteria of selection</a>
                                        <ul>
                                            <li>
                                                <a href="introduction.html#I-2-A-">Material and
                                                  character of monuments</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#I-2-B-">Find Place</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#I-2-C-">Chronological
                                                  framework</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#I-2-D-">Sources</a>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <a href="introduction.html#II-">History of Studies and
                                    Collections</a>
                                <ul>
                                    <li>
                                        <a href="introduction.html#II-1-">End of the XVIIIth – first
                                            half of the XIXth century – an era of travellers and
                                            antiquarians</a>
                                    </li>
                                    <li>
                                        <a href="introduction.html#II-2-">1850-1870s – first
                                            excavations and museums</a>
                                    </li>
                                    <li>
                                        <a href="introduction.html#II-3-">Late XIXth - Early XXth
                                            century – an era of systematic searches and
                                            publications</a>
                                    </li>
                                    <li>
                                        <a href="introduction.html#II-4-">Soviet period – an era of
                                            unsystematic studies</a>
                                    </li>
                                    <li>
                                        <a href="introduction.html#II-5-">1980-2000 – revival of
                                            interest</a>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <a href="introduction.html#III-">Geography and Chronology</a>
                            </li>
                            <li>
                                <a href="introduction.html#IV-">Classification of Inscriptions</a>
                                <ul>
                                    <li>
                                        <a href="introduction.html#IV-1-">Material</a>
                                    </li>
                                    <li>
                                        <a href="introduction.html#IV-2-">Palaeography</a>
                                        <ul>
                                            <li>
                                                <a href="introduction.html#IV-2-A-">Early Byzantine
                                                  Palaeography</a>
                                                <!--<ul>
                                                  <li>
                                                  <a href="introduction.html#IV-2-A-a-">Cherson</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-2-A-b-">Bosporus</a>
                                                  </li>
                                                  </ul>-->
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-2-B-">Middle Byzantine
                                                  Palaeography</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-2-C-">Late Byzantine
                                                  Palaeography</a>
                                                <!--<ul>
                                                  <li>
                                                  <a href="introduction.html#IV-2-C-a-">Coast</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-2-C-b-">Theodoro</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-2-C-c-">Palaeography
                                                  of Mountainous Crimea outside Theodoro</a>
                                                  </li>
                                                  </ul>-->
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="introduction.html#IV-3-">Types of Inscriptions and
                                            Epigraphic Formulae</a>
                                        <ul>
                                            <li>
                                                <a href="introduction.html#IV-3-A-">Building
                                                  Inscriptions</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-3-B-">Dedicatory
                                                  Inscriptions</a>
                                                <!--<ul>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-a-">Δέησις τοῦ
                                                  δούλου τοῦ θεοῦ</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-b-">Ὑπὲρ
                                                  εὐχῆς</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-c-">Ὑπὲρ
                                                  σωτηρίας</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-d-">Ὑπὲρ ψυχικῆς
                                                  σωτηρίας</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-e-">Ὑπὲρ εὐχῆς
                                                  καὶ σωτηρίας</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-f-">Ὑπὲρ ἀφέσεως
                                                  τῶν ἁμαρτιῶν</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-g-">Ὑπὲρ εὐχῆς
                                                  καὶ σωτηρίας καὶ ἀφέσεως τῶν ἁμαρτιῶν</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-h-">Ὑπὲρ
                                                  ὑγιείας</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-B-i-">Oὗ ὁ θεὸς
                                                  οἶδεν τὸ ὄνομα, ἐποίησεν</a>
                                                  </li>
                                                  </ul>-->
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-3-C-"
                                                  >Demonstrative</a>
                                                <!--<ul>
                                                  <li>
                                                  <a href="introduction.html#IV-3-C-a-">Φ(ῶς)
                                                  Χ(ριστοῦ) φ(αίνει) π(ᾶσιν)</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-C-b-">Φῶς, ζωή</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-C-c-">Φῶς</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-C-d-">Α Ω</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-C-e-">Ἰ(ησοῦ)ς
                                                  Χ(ριστὸ)ς νικᾷ</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-C-f-">Κύριος
                                                  φωτισμός μου καὶ σωτήρ μου</a>
                                                  </li>
                                                  </ul>-->
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-3-D-">Apotropaic
                                                  formulae</a>
                                                <!--<ul>
                                                  <li>
                                                  <a href="introduction.html#IV-3-D-a-">Φεῦγε ζῆλος,
                                                  Χριστός σε διώκει</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-D-b-">Σταυροῦ
                                                  προκειμένου, ὁ φθόνος ἀπέστω</a>
                                                  </li>
                                                  </ul>-->
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-3-E-">Invocations</a>
                                                <!--<ul>
                                                  <li>
                                                  <a href="introduction.html#IV-3-E-a-">Κύριε
                                                  (Χριστέ), βοήθει</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-E-b-">Κύριε,
                                                  ἐλέησον</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-E-c-">Κύριε/Σωτήρ,
                                                  σῶσον</a>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-E-d-">Θεοτόκος,
                                                  ...</a>
                                                  </li>
                                                  </ul>-->
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-3-F-">Funerary</a>
                                                <!--<ul>
                                                  <li>
                                                  <a href="introduction.html#IV-3-F-a-"/>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-F-b-"/>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-F-c-"/>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-F-d-"/>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-F-e-"/>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-F-f-"/>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-F-g-"/>
                                                  </li>
                                                  <li>
                                                  <a href="introduction.html#IV-3-F-h-"/>
                                                  </li>
                                                  </ul>-->
                                            </li>
                                        </ul>
                                    </li>

                                    <li>
                                        <a href="introduction.html#IV-4-">Epigraphic dating and
                                            eras</a>
                                        <ul>
                                            <li>
                                                <a href="introduction.html#IV-4-A-">Local eras</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-4-B-">Dating by
                                                  rulers</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-4-C-">The Era "since
                                                  Adam"</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-4-D-">The Era "since
                                                  Creation (of the world)" (Anno Mundi)</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-4-E-">The Era "since
                                                  (the Birth of) Christ"</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-4-F-">Alternative
                                                  Count of Days of the Week</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="introduction.html#IV-5-">The Language of
                                            Inscriptions</a>
                                        <ul>
                                            <li>
                                                <a href="introduction.html#IV-5-A-">Orthography and
                                                  Phonetics</a>
                                            </li>
                                            <li>
                                                <a href="introduction.html#IV-5-B-">Grammar</a>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </xsl:variable>

    <!-- Russian version table of contents for the Introduction -->
    <xsl:variable name="introTOC-ru">
        <div class="row">
            <div class="large-12 columns">
                <div class="collapse-container">
                    <p>
                        <a href="#" class="toggler">Cодержание <span class="fa fa-caret-right"/></a>
                    </p>
                    <div class="expanded hidden-content">
                        <ul>
                            <li>
                                <a href="introduction-ru.html#I-">Содержание и Организация
                                    материала</a>
                                <ul>
                                    <li>
                                        <a href="introduction-ru.html#I-1-">Структура тома</a>
                                        <ul>
                                            <li>
                                                <a href="introduction-ru.html#I-1-A-"
                                                  >Предварительные замечания</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#I-1-B-">Корпус
                                                  надписей</a>

                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#I-1-C-">Указатели и
                                                  конкорданции</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="introduction-ru.html#I-2-">Критерии отбора
                                            надписей</a>
                                        <ul>
                                            <li>
                                                <a href="introduction-ru.html#I-2-A-">Материал и
                                                  характер памятников</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#I-2-B-">Место
                                                  находки</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#I-2-C-"
                                                  >Хронологические рамки</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#I-2-D-">Источники</a>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <a href="introduction-ru.html#II-">История изучения и собирания</a>
                                <ul>
                                    <li>
                                        <a href="introduction-ru.html#II-1-">Конец XVIII – 1-ая
                                            половина XIX в. – эпоха путешественников и
                                            антикваров</a>
                                    </li>
                                    <li>
                                        <a href="introduction-ru.html#II-2-">1850 – 1870-ые годы —
                                            первые раскопки и музеи</a>
                                    </li>
                                    <li>
                                        <a href="introduction-ru.html#II-3-">Конец XIX – начало XX
                                            в. — эпоха систематического поиска и издания</a>
                                    </li>
                                    <li>
                                        <a href="introduction-ru.html#II-4-">Советский период —
                                            эпоха несистематического исследования</a>
                                    </li>
                                    <li>
                                        <a href="introduction-ru.html#II-5-">1980 — 2000-ые годы —
                                            возвращение интереса</a>
                                    </li>
                                </ul>
                            </li>
                            <li>
                                <a href="introduction-ru.html#III-">География и хронология</a>
                            </li>
                            <li>
                                <a href="introduction-ru.html#IV-">Классификация надписей</a>
                                <ul>
                                    <li>
                                        <a href="introduction-ru.html#IV-1-">Носитель</a>
                                    </li>
                                    <li>
                                        <a href="introduction-ru.html#IV-2-">Палеография</a>
                                        <ul>
                                            <li>
                                                <a href="introduction-ru.html#IV-2-A-"
                                                  >Ранневизантийская палеография</a>

                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-2-B-"
                                                  >Средневизантийская палеография</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-2-C-"
                                                  >Поздневизантийская палеография</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="introduction-ru.html#IV-3-">Типы и формулы
                                            надписей</a>
                                        <ul>
                                            <li>
                                                <a href="introduction-ru.html#IV-3-A-"
                                                  >Строительные</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-3-B-"
                                                  >Посвятительные</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-3-C-"
                                                  >Демонстративные</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-3-E-"
                                                  >Инвокативные</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-3-F-"
                                                  >Надгробные</a>
                                            </li>
                                        </ul>
                                    </li>

                                    <li>
                                        <a href="introduction-ru.html#IV-4-">Эпиграфическая
                                            датировка и эры</a>
                                        <ul>
                                            <li>
                                                <a href="introduction-ru.html#IV-4-A-">Локальные
                                                  эры</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-4-B-">Датировки по
                                                  правителям</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-4-C-">Эра «от
                                                  Адама»</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-4-D-">Эра «от
                                                  сотворения мира»</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-4-E-">Эра «от
                                                  Христа»</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-4-F-"
                                                  >Альтернативный счет дней недели</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="introduction-ru.html#IV-5-">Язык надписей</a>
                                        <ul>
                                            <li>
                                                <a href="introduction-ru.html#IV-5-A-">Орфография и
                                                  фонетика</a>
                                            </li>
                                            <li>
                                                <a href="introduction-ru.html#IV-5-B-"
                                                  >Грамматика</a>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </xsl:variable>



</xsl:stylesheet>

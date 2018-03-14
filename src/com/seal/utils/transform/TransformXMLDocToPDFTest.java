package com.seal.utils.transform;

//Java
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.Collection;
import java.util.Iterator;
import java.util.logging.Logger;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.FileUtils;
import org.apache.fop.apps.FOUserAgent;
import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;

import com.itextpdf.text.Document;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;

/**
 * This class demonstrates the conversion of an XML file to PDF using JAXP
 * (XSLT) and FOP (XSL-FO).
 */
public class TransformXMLDocToPDFTest
{

	private static final Logger _LOG = Logger
			.getLogger(TransformXMLDocToPDFTest.class.getName());

	/**
	 * Main method.
	 * 
	 * @param args
	 *            command-line arguments
	 */
	public static void main(String[] args) throws Exception
	{
		
		Document document = null;
        FileOutputStream outputStream = null;
        
		try
		{
			System.out.println("FOP ExampleXML2PDF\n");
			System.out.println("Preparing...");

			// Setup directories
			File baseDir = new File("src");
			File outDir = new File("out");
			outDir.mkdirs();

			// Setup input and output files
			File xsltfile = new File(baseDir, "../xslt/SealDocumentExport.xsl");
			File mergedPDF = new File(outDir, "MergedXMLOutput.pdf");
			File inputDir = new File("input");
			
			// Initialize pdf output
			document = new Document();
	        outputStream = new FileOutputStream(mergedPDF);
	        PdfWriter writer = PdfWriter.getInstance(document, outputStream);
	        document.open();
	        PdfContentByte cb = writer.getDirectContent();

			System.out.println("Stylesheet: " + xsltfile);

			String[] extensions = new String[] { "xml" };
			Collection<File> importDirFiles = FileUtils.listFiles(inputDir,
					extensions, true);

			Iterator<File> i = importDirFiles.iterator();

			System.out.println("Processing list of files in directory: "
					+ inputDir.getCanonicalPath() + " Number of files: "
					+ importDirFiles.size());

			int fileCount = 1;
			// Process each file and generate a PDF!
			while (i.hasNext())
			{
				// Get the next file
				File xmlfile = i.next();
				// Only process files.
				if (!xmlfile.isDirectory())
				{
					System.out.println("Processing input file: " +xmlfile.getCanonicalPath());
					// configure fopFactory as desired
					FopFactory fopFactory = FopFactory.newInstance(xmlfile);
					// configure foUserAgent as desired
					FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
					
					// Create new output file.
					File pdffile = new File(outDir, "SealDocument-" + fileCount
							+ ".pdf");
					System.out.println("Output: PDF (" + pdffile + ")");
					// Setup output
					OutputStream out = new java.io.FileOutputStream(pdffile);
					try
					{
						out = new java.io.BufferedOutputStream(out);

						// Construct fop with desired output format
						Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF,
								foUserAgent, out);

						// Setup XSLT
						TransformerFactory factory = TransformerFactory
								.newInstance();
						Transformer transformer = factory
								.newTransformer(new StreamSource(xsltfile));

						// Setup input for XSLT transformation
						Source src = new StreamSource(xmlfile);

						// Resulting SAX events (the generated FO) must be piped
						// through
						// to FOP
						Result res = new SAXResult(fop.getDefaultHandler());

						// Start XSLT transformation and FOP processing
						transformer.transform(src, res);
						System.out.println("After transform");
						fileCount++;		
					}
					catch (Exception e)
					{
						System.out.println("Found error!");
						e.printStackTrace(System.err);
						System.exit(-1);
					}
					finally
					{
						// Close the file we are done processing it.
						out.close();
						// Append this newly converted PDF 
						PdfReader reader = new PdfReader(pdffile.getAbsolutePath());
			            for (int n = 1; n <= reader.getNumberOfPages(); n++) {
			                document.newPage();
			                PdfImportedPage page = writer.getImportedPage(reader, n);
			                cb.addTemplate(page, 0, 0);
			            }
					}
				}
			}
			System.out.println("Writing out merged PDF file: " +mergedPDF.getCanonicalPath());
		}
		catch (Exception e)
		{
			System.out.println("Found error!");
			e.printStackTrace(System.err);
			System.exit(-1);
		}
		finally
		{
			outputStream.flush();
	        document.close();
	        outputStream.close();
		}
	}
	
}
